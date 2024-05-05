package com.salesianos.dam.StudentGoApi;

import com.salesianos.dam.StudentGoApi.model.Purchase;
import com.salesianos.dam.StudentGoApi.repository.PurchaseRepository;
import com.salesianos.dam.StudentGoApi.service.QRService;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class AppInitializer {

    private final PurchaseRepository purchaseRepository;
    private final QRService qrCodeService;

    @Autowired
    public AppInitializer(PurchaseRepository purchaseRepository, QRService qrCodeService) {
        this.purchaseRepository = purchaseRepository;
        this.qrCodeService = qrCodeService;
    }

    @PostConstruct
    public void generateQRForExistingPurchases() {
        Iterable<Purchase> purchases = purchaseRepository.findAll();
        for (Purchase purchase : purchases) {
            try {
                String qrCode = qrCodeService.generateQRCode(purchase.getUuid().toString());
                purchase.setQrCode(qrCode);
                purchaseRepository.save(purchase);
            } catch (Exception e) {
                // Manejar cualquier excepción que pueda ocurrir al generar el código QR
            }
        }
    }
}