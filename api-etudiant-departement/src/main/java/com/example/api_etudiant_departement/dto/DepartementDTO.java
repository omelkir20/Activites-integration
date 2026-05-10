package com.example.api_etudiant_departement.dto;

import lombok.Data;
import java.io.Serializable;

@Data
public class DepartementDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    private Long id;
    private String nom;
}
