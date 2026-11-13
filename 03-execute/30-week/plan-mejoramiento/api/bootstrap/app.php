<?php
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use App\Exceptions\ApiException;
use App\Http\Middleware\AuthenticateOperator;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(api: __DIR__.'/../routes/api.php', commands: __DIR__.'/../routes/console.php')
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias(['operator' => AuthenticateOperator::class]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (\Throwable $error, Request $request) {
            if (!$request->is('api/*')) return null;
            if ($error instanceof ApiException) {
                return response()->json(['code'=>$error->errorCode,'message'=>$error->getMessage(),'details'=>$error->details],$error->status);
            }
            if ($error instanceof ValidationException) {
                $details=[];
                foreach ($error->errors() as $field=>$messages) foreach ($messages as $message) $details[]=['field'=>$field,'issue'=>$message];
                return response()->json(['code'=>'VALIDATION_ERROR','message'=>'Datos no válidos.','details'=>$details],422);
            }
            if ($error instanceof HttpExceptionInterface) {
                $status=$error->getStatusCode();
                return response()->json(['code'=>$status===404?'NOT_FOUND':($status===403?'FORBIDDEN_ROLE':'HTTP_ERROR'),'message'=>$status===404?'Recurso no encontrado.':'No se pudo completar la solicitud.','details'=>[]],$status);
            }
            report($error);
            return response()->json(['code'=>'INTERNAL_ERROR','message'=>'Error interno del servidor.','details'=>[]],500);
        });
    })->create();
