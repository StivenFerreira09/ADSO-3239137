<?php
namespace App\Application;

use App\Ports\RentalPort;

final class ReturnUseCase {
    public function __construct(private RentalPort $store) {}

    public function execute(string $rentalId,string $itemId):array {
        return $this->store->returnItem($rentalId,$itemId);
    }
}
