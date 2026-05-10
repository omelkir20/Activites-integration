package com.example.api_etudiant_departement;

import com.example.api_etudiant_departement.entity.Etudiant;
import com.example.api_etudiant_departement.repository.EtudiantRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import java.time.LocalDate;
import java.util.List;

@Component
public class DataInitializer implements CommandLineRunner {

    private final EtudiantRepository repo;

    public DataInitializer(EtudiantRepository repo) {
        this.repo = repo;
    }

    @Override
    public void run(String... args) {
        if (repo.count() == 0) {
            repo.saveAll(List.of(
                    creer("CIN001", "Ali Ben Salem",  LocalDate.of(2000, 3, 15),  "ali@email.com",    2019),
                    creer("CIN002", "Sana Trabelsi",  LocalDate.of(2001, 7, 22),  "sana@email.com",   2020),
                    creer("CIN003", "Mohamed Haddad", LocalDate.of(1999, 11, 5),  "mohamed@email.com",2018),
                    creer("CIN004", "Fatma Mansour",  LocalDate.of(2002, 1, 18),  "fatma@email.com",  2021),
                    creer("CIN005", "Youssef Karoui", LocalDate.of(2000, 9, 30),  "youssef@email.com",2019)
            ));
        }
    }

    private Etudiant creer(String cin, String nom, LocalDate date, String email, int annee) {
        Etudiant e = new Etudiant();
        e.setCin(cin);
        e.setNom(nom);
        e.setDateNaissance(date);
        e.setEmail(email);
        e.setAnneePremiereInscription(annee);
        return e;
    }
}