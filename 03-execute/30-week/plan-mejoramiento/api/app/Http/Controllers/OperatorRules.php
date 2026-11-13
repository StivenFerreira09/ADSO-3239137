<?php
namespace App\Domain;
use InvalidArgumentException;
final class OperatorRules {
    public static function username(string $name):string {return strtolower(trim($name));}
    public static function role(string $role):string {
        if ($role!=='advisor') throw new InvalidArgumentException('Solo se permite crear usuarios asesores.');
        return $role;
    }
}
