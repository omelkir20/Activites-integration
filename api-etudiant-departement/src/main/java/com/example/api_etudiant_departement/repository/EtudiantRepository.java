package com.example.api_etudiant_departement.repository;

import com.example.api_etudiant_departement.entity.Etudiant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EtudiantRepository extends JpaRepository<Etudiant, Long> {}