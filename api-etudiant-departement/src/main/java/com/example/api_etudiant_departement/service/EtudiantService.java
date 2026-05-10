package com.example.api_etudiant_departement.service;

import com.example.api_etudiant_departement.dto.EtudiantDTO;
import com.example.api_etudiant_departement.entity.Etudiant;
import com.example.api_etudiant_departement.mapper.EtudiantMapper;
import com.example.api_etudiant_departement.repository.EtudiantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EtudiantService {

    private final EtudiantRepository repo;
    private final EtudiantMapper mapper;

    @Cacheable(value = "etudiants")
    public List<EtudiantDTO> findAll() {
        return repo.findAll().stream().map(mapper::toDTO).toList();
    }

    public EtudiantDTO findById(Long id) {
        Etudiant e = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Etudiant non trouvé : " + id));
        return mapper.toDTO(e);
    }

    @CacheEvict(value = "etudiants", allEntries = true)
    public EtudiantDTO save(EtudiantDTO dto) {
        Etudiant e = mapper.toEntity(dto);
        return mapper.toDTO(repo.save(e));
    }

    @CacheEvict(value = "etudiants", allEntries = true)
    public EtudiantDTO update(Long id, EtudiantDTO dto) {
        Etudiant e = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Etudiant non trouvé : " + id));
        e.setCin(dto.getCin());
        e.setNom(dto.getNom());
        e.setDateNaissance(dto.getDateNaissance());
        e.setEmail(dto.getEmail());
        e.setAnneePremiereInscription(dto.getAnneePremiereInscription());
        return mapper.toDTO(repo.save(e));
    }

    @CacheEvict(value = "etudiants", allEntries = true)
    public void delete(Long id) {
        repo.deleteById(id);
    }

    public List<EtudiantDTO> findByAnnee(int annee) {
        return repo.findByAnneePremiereInscription(annee)
                .stream().map(mapper::toDTO).toList();
    }
}
