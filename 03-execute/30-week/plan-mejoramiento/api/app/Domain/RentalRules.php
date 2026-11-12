<?php
namespace App\Domain;
use InvalidArgumentException;
use DateTimeImmutable;
use DateTimeZone;
final class RentalRules {
    public static function validateSelection(array $ids, int $activeCount, bool $hasOverdue):void {
        if (count($ids)<1 || count($ids)>3) throw new InvalidArgumentException('Debe incluir entre 1 y 3 trajes.');
        if (count(array_unique($ids))!==count($ids)) throw new InvalidArgumentException('No puede repetir un traje dentro del alquiler.');
        if ($hasOverdue) throw new InvalidArgumentException('El cliente tiene alquileres vencidos.');
        if ($activeCount+count($ids)>5) throw new InvalidArgumentException('El cliente supera el límite de 5 trajes.');
    }
    public static function dueAt(DateTimeImmutable $rentedAt):DateTimeImmutable {return $rentedAt->setTimezone(new DateTimeZone('UTC'))->modify('+4 days');}
    public static function status(array $items,DateTimeImmutable $now):string {
        $open=array_filter($items,fn($item)=>empty($item['returned_at']));
        if (!$open) return 'closed';
        foreach ($open as $item) if(new DateTimeImmutable($item['due_at'])<$now) return 'overdue';
        return 'open';
    }
}
