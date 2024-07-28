# NFT Marketplace

Bu proje, Ethereum blockchain üzerinde çalışan bir NFT (Non-Fungible Token) pazar yeridir. Kullanıcılar, ERC-721 standardındaki NFT'leri basabilir, satabilir ve satın alabilirler.

## İçindekiler

1. [Gereksinimler](#gereksinimler)
2. [Kurulum](#kurulum)
3. [Geliştirme](#geliştirme)
   - [Akıllı Sözleşmeleri Derleme](#akıllı-sözleşmeleri-derleme)
   - [Testler](#testler)
   - [Yerel Ağda Çalıştırma](#yerel-ağda-çalıştırma)
   - [Sepolia Ağına Dağıtım](#sepolia-ağına-dağıtım)
4. [Kullanım](#kullanım)
   - [NFT Basma](#nft-basma)
   - [NFT Satışı Başlatma](#nft-satışı-başlatma)
   - [NFT Satın Alma](#nft-satın-alma)
5. [Katkıda Bulunma](#katkıda-bulunma)
6. [Lisans](#lisans)

## Gereksinimler

- Node.js (>= 14.x)
- npm veya yarn
- Hardhat
- Ethers.js

## Kurulum

Proje dizininde aşağıdaki adımları izleyerek kurulumu gerçekleştirin:

1. Depoyu klonlayın:

    ```sh
    git clone https://github.com/kullanici/nft-marketplace.git
    ```

2. Proje dizinine gidin:

    ```sh
    cd nft-marketplace
    ```

3. Bağımlılıkları yükleyin:

    ```sh
    npm install
    ```

    veya

    ```sh
    yarn install
    ```

4. `.env` dosyasını oluşturun ve gerekli çevresel değişkenleri ayarlayın:

    ```env
    INFURA_PROJECT_ID=your-infura-project-id
    DEPLOYER_PRIVATE_KEY=your-private-key
    ```

## Geliştirme

### Akıllı Sözleşmeleri Derleme

Aşağıdaki komutu çalıştırarak akıllı sözleşmeleri derleyin:

```sh
npx hardhat compile
