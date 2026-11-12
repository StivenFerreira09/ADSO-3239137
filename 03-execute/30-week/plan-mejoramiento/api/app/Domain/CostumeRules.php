<?php
namespace App\Domain;
use InvalidArgumentException;
final class CostumeRules {
    public static function changeTotal(int $oldTotal,int $available,int $newTotal):int {
        if ($newTotal<1 || $available+$newTotal-$oldTotal<0) throw new InvalidArgumentException('La cantidad total no permite cubrir los alquileres activos.');
        return $available+$newTotal-$oldTotal;
    }
    public static function withdraw(int $available):int {
        if ($available<1) throw new InvalidArgumentException('No hay unidades disponibles.');
        return $available-1;
    }
    public static function restock(int $available,int $total):int {
        if ($available>=$total) throw new InvalidArgumentException('Las unidades superan el total.');
        return $available+1;
    }
}
