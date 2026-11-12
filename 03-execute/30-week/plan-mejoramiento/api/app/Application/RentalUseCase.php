<?php
namespace App\Application;
use App\Ports\RentalPort;
use App\Exceptions\ApiException;
final class RentalUseCase {
    public function __construct(private RentalPort $store) {}
    public function execute(string $customerId,string $operatorId,array $costumeIds):array {
        if(count($costumeIds)<1||count($costumeIds)>3) throw new ApiException('VALIDATION_ERROR','El alquiler debe tener entre 1 y 3 trajes.',422);
        if(count($costumeIds)!==count(array_unique($costumeIds))) throw new ApiException('DUPLICATE_COSTUME_IN_RENTAL','Un mismo traje no puede repetirse.',422);
        return $this->store->create($customerId,$operatorId,$costumeIds);
    }
}
