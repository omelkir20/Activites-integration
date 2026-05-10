package com.example.api_etudiant_departement.controller;

import com.example.api_etudiant_departement.dto.DepartementDTO;
import com.example.api_etudiant_departement.service.DepartementService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/departements")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class DepartementController {

    private final DepartementService service;

    @GetMapping
    public List<DepartementDTO> getAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public DepartementDTO getById(@PathVariable Long id) {
        return service.findById(id);
    }

    @PostMapping
    public ResponseEntity<DepartementDTO> create(@RequestBody DepartementDTO dto) {
        return ResponseEntity.status(201).body(service.save(dto));
    }

    @PutMapping("/{id}")
    public DepartementDTO update(@PathVariable Long id, @RequestBody DepartementDTO dto) {
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}