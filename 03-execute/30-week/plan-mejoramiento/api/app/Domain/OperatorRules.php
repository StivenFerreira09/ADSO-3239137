<?php
namespace App\Domain;
use InvalidArgumentException;
final class OperatorRules {
    public static function assertCreatableRole(string $role):void {
        if ($role!=='advisor') throw new InvalidArgumentException('Solo se pueden crear asesores.');
    }
}
