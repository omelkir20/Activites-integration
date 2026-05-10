package com.example.api_etudiant_departement.steps;

import com.example.api_etudiant_departement.entity.Etudiant;
import io.cucumber.java.fr.Alors;
import io.cucumber.java.fr.Etantdonné;
import io.cucumber.java.fr.Quand;
import java.time.LocalDate;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class EtudiantSteps {

    private Etudiant etudiant;
    private int age;

    @Etantdonné("un étudiant avec la date de naissance {string}")
    public void unEtudiantAvecDateNaissance(String date) {
        etudiant = new Etudiant();
        etudiant.setDateNaissance(LocalDate.parse(date));
    }

    @Quand("on calcule son âge")
    public void onCalculeSonAge() {
        age = etudiant.age();
    }

    @Alors("l'âge retourné doit être {int}")
    public void lAgeRetourneDoitEtre(int ageAttendu) {
        assertEquals(ageAttendu, age);
    }
}