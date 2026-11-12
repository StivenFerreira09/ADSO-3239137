<?php
namespace App\Domain;
use InvalidArgumentException;
final class DateRange {
    public static function validate(string $from,string $to):void {
        if ($to<$from) throw new InvalidArgumentException('La fecha final no puede ser anterior a la inicial.');
    }
}
