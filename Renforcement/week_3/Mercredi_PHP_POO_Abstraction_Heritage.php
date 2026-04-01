<?php

abstract class Vehicule {
    protected $marque;
    protected $modele;
    protected $annee;
    protected $prixBase;

    public function __construct($marque, $modele, $annee, $prixBase) {
        $this->marque = $marque;
        $this->modele = $modele;
        $this->annee = $annee;
        $this->prixBase = $prixBase;
    }


    public function getMarque() { return $this->marque; }
    public function getModele() { return $this->modele; }
    public function getAnnee() { return $this->annee; }
    public function getPrixBase() { return $this->prixBase; }


    abstract public function getPrixFinal(): float;
    abstract public function getDescription(): string;
}


// voiture

class Voiture extends Vehicule {
    private $fraisMiseEnRoute = 150;

    public function getPrixFinal(): float {
        return $this->prixBase + $this->fraisMiseEnRoute;
    }

    public function getDescription(): string {
        return "Voiture : {$this->marque} {$this->modele} ({$this->annee})";
    }
}

// moto

class Moto extends Vehicule {
    private $remiseAncienne = 0.05;

    public function getPrixFinal(): float {
        if ($this->annee < 2020) {
            return $this->prixBase * (1 - $this->remiseAncienne);
        }
        return $this->prixBase;
    }

    public function getDescription(): string {
        return "Moto : {$this->marque} {$this->modele} ({$this->annee})";
    }
}

// camionnette

class Camionnette extends Vehicule {
    private $chargeUtile;

    public function __construct($marque, $modele, $annee, $prixBase, $chargeUtile) {
        parent::__construct($marque, $modele, $annee, $prixBase);
        $this->chargeUtile = $chargeUtile;
    }

    public function getPrixFinal(): float {
        return $this->prixBase + ($this->chargeUtile * 0.10);
    }

    public function getDescription(): string {
        return "Camionnette : {$this->marque} {$this->modele} ({$this->annee}) - Charge : {$this->chargeUtile}kg";
    }
}

//catalogue 

$catalogue = [
    new Voiture("Toyota", "Corolla", 2022, 20000),
    new Voiture("BMW", "Serie 3", 2021, 35000),
    new Moto("Yamaha", "MT-07", 2019, 7000),
    new Camionnette("Renault", "Kangoo", 2020, 18000, 800)
];

$total = 0;

foreach ($catalogue as $vehicule) {
    echo $vehicule->getDescription() . " - Prix final : " . $vehicule->getPrixFinal() . "dh\n";
    $total += $vehicule->getPrixFinal();
}


$prixMoyen = $total / count($catalogue);
echo "Prix moyen du catalogue : " . $prixMoyen . "dh";