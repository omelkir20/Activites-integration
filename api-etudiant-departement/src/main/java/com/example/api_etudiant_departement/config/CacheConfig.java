package com.example.api_etudiant_departement.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.example.api_etudiant_departement.dto.DepartementDTO;
import com.example.api_etudiant_departement.dto.EtudiantDTO;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory connectionFactory) {

        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        // Serializer pour List<EtudiantDTO>
        Jackson2JsonRedisSerializer<List<EtudiantDTO>> etudiantSerializer =
                new Jackson2JsonRedisSerializer<>(mapper,
                        mapper.getTypeFactory().constructCollectionType(List.class, EtudiantDTO.class));

        // Serializer pour List<DepartementDTO>
        Jackson2JsonRedisSerializer<List<DepartementDTO>> departementSerializer =
                new Jackson2JsonRedisSerializer<>(mapper,
                        mapper.getTypeFactory().constructCollectionType(List.class, DepartementDTO.class));

        // Config par défaut (etudiants)
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(10))
                .serializeValuesWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(etudiantSerializer)
                );

        // Config spécifique pour departements
        RedisCacheConfiguration departementsConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(10))
                .serializeValuesWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(departementSerializer)
                );

        // Map chaque cache avec son serializer
        Map<String, RedisCacheConfiguration> cacheConfigs = new HashMap<>();
        cacheConfigs.put("etudiants", defaultConfig);
        cacheConfigs.put("departements", departementsConfig);

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(defaultConfig)
                .withInitialCacheConfigurations(cacheConfigs)
                .build();
    }
}