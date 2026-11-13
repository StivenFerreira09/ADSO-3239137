<?php
return ['paths'=>['api/*'],'allowed_methods'=>['*'],'allowed_origins'=>[env('CORS_ORIGIN','http://localhost:5173')],'allowed_origins_patterns'=>[],'allowed_headers'=>['*'],'exposed_headers'=>[],'max_age'=>3600,'supports_credentials'=>false];
