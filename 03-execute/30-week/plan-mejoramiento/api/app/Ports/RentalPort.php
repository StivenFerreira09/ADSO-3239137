<?php
namespace App\Ports;
interface RentalPort {
    public function create(string $customerId,string $operatorId,array $costumeIds):array;
    public function returnItem(string $rentalId,string $itemId):array;
}
