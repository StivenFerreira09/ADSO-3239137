<?php
namespace App\Exceptions;
use RuntimeException;
final class ApiException extends RuntimeException {
    public function __construct(public string $errorCode, string $message, public int $status=422, public array $details=[]) {parent::__construct($message);}
}
