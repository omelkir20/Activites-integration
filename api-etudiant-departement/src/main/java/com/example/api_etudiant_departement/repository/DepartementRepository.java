package com.example.api_etudiant_departement.repository;

import com.example.api_etudiant_departement.entity.Departement;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DepartementRepository extends JpaRepository<Departement, Long> {
}