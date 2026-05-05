package com.example.api_etudiant_departement.controller;

import com.example.api_etudiant_departement.entity.Etudiant;
import com.example.api_etudiant_departement.repository.EtudiantRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/etudiants")
@CrossOrigin(origins = "*")
public class EtudiantController {

    private final EtudiantRepository repo;

    public EtudiantController(EtudiantRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Etudiant> getAll() {
        return repo.findAll();
    }
}