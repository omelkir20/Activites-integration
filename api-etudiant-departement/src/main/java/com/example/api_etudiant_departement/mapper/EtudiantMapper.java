package com.example.api_etudiant_departement.mapper;

import com.example.api_etudiant_departement.dto.EtudiantDTO;
import com.example.api_etudiant_departement.entity.Etudiant;
import org.springframework.stereotype.Component;

@Component
public class EtudiantMapper {

    public EtudiantDTO toDTO(Etudiant e) {
        EtudiantDTO dto = new EtudiantDTO();
        dto.setId(e.getId());
        dto.setCin(e.getCin());
        dto.setNom(e.getNom());
        dto.setDateNaissance(e.getDateNaissance());
        dto.setEmail(e.getEmail());
        dto.setAnneePremiereInscription(e.getAnneePremiereInscription());
        dto.setAge(e.age());
        if (e.getDepartement() != null) {
            dto.setDepartementId(e.getDepartement().getId());
            dto.setDepartementNom(e.getDepartement().getNom());
        }
        return dto;
    }

    public Etudiant toEntity(EtudiantDTO dto) {
        Etudiant e = new Etudiant();
        e.setCin(dto.getCin());
        e.setNom(dto.getNom());
        e.setDateNaissance(dto.getDateNaissance());
        e.setEmail(dto.getEmail());
        e.setAnneePremiereInscription(dto.getAnneePremiereInscription());
        return e;
    }
}