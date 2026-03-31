<?php

class CompteBancaire {

    private $titulaire;
    private $iban;
    private $solde;

    public function __construct($titulaire,$iban,$solde=0) {
        $this->titulaire = $titulaire;
        $this->iban = $iban;
        $this->solde = $solde;
    }

    public function getTitulaire() {
        return $this->titulaire;
    }

    public function getIban() {
        return $this->iban;
    }

    public function getSolde() {
        return $this->solde;
    }

    public function deposer($montant) {
        if ($montant > 0) {
            $this->solde += $montant;
        }
    }
    public function retirer($montant) {
        if ($montant > 0 && $montant <= $this->solde) {
            $this->solde -= $montant;
        }
    }

    public function afficherInfos() {
        echo "Titulaire: " . $this->titulaire . "\n";
        echo "IBAN: " . $this->iban . "\n";
        echo "Solde: " . $this->solde . " dh\n";
    }

}

$compte1 = new CompteBancaire("Alice Dupont", "FR76 3000 6000 0112 3456 7890 123", 1000);
$compte2 = new CompteBancaire("Bob Martin", "FR14 2000 4000 0123 4567 8901 234", 500);

$compte1->deposer(200);
$compte1->retirer(150);

$compte1->afficherInfos();


$compte2->deposer(300);
$compte2->retirer(100);

$compte2->afficherInfos();
