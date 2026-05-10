package com.example.api_etudiant_departement.service;

import com.example.api_etudiant_departement.dto.DepartementDTO;
import com.example.api_etudiant_departement.entity.Departement;
import com.example.api_etudiant_departement.repository.DepartementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DepartementService {

    private final DepartementRepository repo;

    @Cacheable(value = "departements")
    public List<DepartementDTO> findAll() {
        return repo.findAll().stream().map(this::toDTO).toList();
    }

    public DepartementDTO findById(Long id) {
        Departement d = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Département non trouvé : " + id));
        return toDTO(d);
    }

    @CacheEvict(value = "departements", allEntries = true)
    public DepartementDTO save(DepartementDTO dto) {
        Departement d = new Departement();
        d.setNom(dto.getNom());
        return toDTO(repo.save(d));
    }

    @CacheEvict(value = "departements", allEntries = true)
    public DepartementDTO update(Long id, DepartementDTO dto) {
        Departement d = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Département non trouvé : " + id));
        d.setNom(dto.getNom());
        return toDTO(repo.save(d));
    }

    @CacheEvict(value = "departements", allEntries = true)
    public void delete(Long id) {
        repo.deleteById(id);
    }

    private DepartementDTO toDTO(Departement d) {
        DepartementDTO dto = new DepartementDTO();
        dto.setId(d.getId());
        dto.setNom(d.getNom());
        return dto;
    }
}