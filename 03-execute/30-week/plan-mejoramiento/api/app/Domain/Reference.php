<?php
namespace App\Domain;
use InvalidArgumentException;
final class Reference {
    public static function normalize(string $value):string {
        $value=strtoupper(trim($value));
        if(!preg_match('/^[A-Z0-9-]{2,50}$/',$value)) throw new InvalidArgumentException('La referencia debe contener de 2 a 50 letras, números o guiones.');
        return $value;
    }
}
