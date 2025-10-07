-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 07 oct. 2025 à 10:20
-- Version du serveur : 11.8.3-MariaDB-log
-- Version de PHP : 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `u416167129_soelevate25`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`u416167129_soelevate25dm`@`127.0.0.1` PROCEDURE `sp_resa_recompute` (IN `p_reservation_id` BIGINT)   BEGIN
  DECLARE v_capacity INT UNSIGNED;
  DECLARE v_count INT UNSIGNED;

  SELECT `capacity` INTO v_capacity
  FROM `reservation` WHERE `id` = p_reservation_id FOR UPDATE;

  SELECT COUNT(*) INTO v_count
  FROM `reserver`
  WHERE `reservation_id` = p_reservation_id
    AND `status` <> 'Annulé';

  UPDATE `reservation`
     SET `reserved_count` = v_count,
         `is_open` = CASE WHEN v_count < v_capacity THEN 1 ELSE 0 END,
         `updated_at` = NOW()
   WHERE `id` = p_reservation_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `administrateurs`
--

CREATE TABLE `administrateurs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(120) NOT NULL,
  `email` varchar(191) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `role` enum('Administrateur','SuperAdmin') NOT NULL DEFAULT 'Administrateur',
  `actif` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `administrateurs`
--

INSERT INTO `administrateurs` (`id`, `nom`, `email`, `mot_de_passe`, `role`, `actif`, `created_at`, `updated_at`) VALUES
(2, 'lynda', 'contact@hldigital.fr', '$2y$10$AemrJb4ajzCUYPF77BoIBuaVOLOLlvU7zAjyuGeWvjLdd0hw32MmO', 'Administrateur', 1, '2025-09-26 20:13:45', '2025-09-26 20:13:45'),
(3, 'Cyrlain', 'cyrlain50@gmail.com', '$2y$10$beOsDC2ElWK/M3jWpTmfO.suHzVDbcT8dlzILQOachKjJlbFLbFka', 'Administrateur', 1, '2025-09-30 23:30:55', '2025-09-30 23:30:55'),
(4, 'HADDAD LYNDA', 'lynda-haddad@hotmail.fr', '$2y$10$odbX5Gasxrv9hDlHAWRpueKtP3tXq5Wv0sezqYbliRm7ob7ntbbM6', 'Administrateur', 1, '2025-10-03 22:50:05', '2025-10-03 22:50:05');

-- --------------------------------------------------------

--
-- Structure de la table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(80) NOT NULL,
  `last_name` varchar(80) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `email` varchar(190) NOT NULL,
  `message` text NOT NULL,
  `website_hp` varchar(255) DEFAULT NULL,
  `captcha_expected` varchar(10) DEFAULT NULL,
  `captcha_answered` varchar(10) DEFAULT NULL,
  `is_spam` tinyint(1) NOT NULL DEFAULT 0,
  `ip` varbinary(16) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `status` enum('new','sent','error') NOT NULL DEFAULT 'new',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `contact_page`
--

CREATE TABLE `contact_page` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `hero` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`hero`)),
  `assets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`assets`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `contact_page`
--

INSERT INTO `contact_page` (`id`, `hero`, `assets`, `created_at`, `updated_at`) VALUES
(1, '{\"title\": \"Contact\", \"subtitle\": \"Une question, une demande d’accompagnement ou un devis pour une intervention en entreprise ? Écris-moi via ce formulaire, je te réponds rapidement.\"}', '{\"footer_band\": \"img/footer.jpg\"}', '2025-09-23 21:44:27', '2025-09-23 21:44:27');

-- --------------------------------------------------------

--
-- Structure de la table `demandes_entreprise`
--

CREATE TABLE `demandes_entreprise` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `societe` varchar(255) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `objet` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `status` enum('Nouveau','En attente','Traité','Refusé') NOT NULL DEFAULT 'Nouveau',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `demandes_entreprise`
--

INSERT INTO `demandes_entreprise` (`id`, `societe`, `prenom`, `nom`, `email`, `phone`, `objet`, `message`, `status`, `created_at`, `updated_at`) VALUES
(1, 'hhjhjjhjh', 'jjjjkjk', 'jjkjkjk', 'jerredjr@gmail.com', '7889898989', 'hhhjhjjd', 'hjhjhjhhf', 'En attente', '2025-10-04 11:49:30', NULL),
(2, 'fjjfjfjkf', 'hjjhjj', 'jjjkjjkkj', 'jerredjr@gmail.com', '455878898', 'jhhfdhfhjf', 'fhhjhhhfhhf', 'En attente', '2025-10-04 11:50:57', NULL),
(3, 'fjjfjfjkf', 'hjjhjj', 'jjjkjjkkj', 'jerredjr@gmail.com', '455878898', 'jhhfdhfhjf', 'fhhjhhhfhhf', 'En attente', '2025-10-04 12:09:48', NULL),
(4, 'trtrrtrtrtrt', 'rrttffftff', 'tytytytygyg', 'jerredjr@gmail.com', '684648864665', 'dtrrtftytfty', 'ytyttytytytygu', 'En attente', '2025-10-04 12:12:53', NULL),
(5, 'huyuuyyu', 'ghyuuyuyuy', 'gyuyyyuuy', 'jerredjr@gmail.com', '885985589555', 'yttytytygtyg', 'uuyuyyueyuye', 'En attente', '2025-10-04 13:05:58', NULL),
(6, 'hhhjfhhjf', 'hjjhjhhjf', 'hhjhfhf', 'jerredjr@gmail.com', '45466464646', 'fhfhfhvvhhv', 'hfhjhjghjghjgjjghjgg', 'En attente', '2025-10-04 19:52:37', NULL),
(7, 'ieioioeiiiiio', 'jffioififfio', 'ffiififiif', 'jerredjr@gmail.com', '6565655656555', 'hhjfhhfhf', 'hffjfjkjfkjkfjkfjkfjkkfjjkfjkfjjfkjfjkfjkf', 'En attente', '2025-10-05 21:44:47', NULL),
(8, 'advezns', 'lynda', 'haddad', 'lynda-haddad@hotmail.fr', '0328211098', 'dfoidufiudfhdiofjhuiofjdklhuirefodlkjnbheiodlskfnbhjgedklsf,;njdksl;', 'bb tkt t torp bellllllll', 'En attente', '2025-10-05 22:07:00', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `entreprises_page`
--

CREATE TABLE `entreprises_page` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `hero` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`hero`)),
  `assets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`assets`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `entreprises_page`
--

INSERT INTO `entreprises_page` (`id`, `hero`, `assets`, `created_at`, `updated_at`) VALUES
(1, '{\"title\": \"Des expériences\\nsensorielles\\npour une QVCT\\ndurable\", \"text_html\": \"Une méthode active, fondée sur des expériences sensorielles qui renforce la cohésion d’équipe, booste la performance collective et stimule l’énergie durablement — pour retrouver une qualité de vie au travail et réduire le stress.\", \"cta\": {\"label\": \"Demander un devis\", \"link\": \"devis.php\"}}', '{\"hero_image\": \"img/entreprise.jpg\", \"footer_band\": \"img/footer.jpg\"}', '2025-09-23 18:47:50', '2025-10-01 20:35:32');

-- --------------------------------------------------------

--
-- Structure de la table `formules_page`
--

CREATE TABLE `formules_page` (
  `id` int(11) NOT NULL,
  `intro` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`intro`)),
  `plans` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`plans`)),
  `footer_links` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`footer_links`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `formules_page`
--

INSERT INTO `formules_page` (`id`, `intro`, `plans`, `footer_links`, `created_at`, `updated_at`) VALUES
(1, '{\"title\":\"Mes formules\",\"lead_html\":\"<p>Que vous souhaitiez découvrir, approfondir ou transformer durablement votre énergie, mes formules s’adaptent à vos besoins. De la séance individuelle à l’immersion complète, chaque parcours est pensé pour offrir une expérience sensorielle unique et progressive.</p>\"}', '[{\"image\":\"img/image 1.jpg\",\"title\":\"SO ELEVATE FOR YOU\",\"subtitle_html\":\"Séance individuelle\",\"link\":\"soelevate.html\"},{\"image\":\"img/image2.jpg\",\"title\":\"PACK RESET\",\"subtitle_html\":\"Durée : ½ journée\",\"link\":\"packreset.html\"},{\"image\":\"img/image 3.jpg\",\"title\":\"PACK LEVEL UP\",\"subtitle_html\":\"Durée : 1 journée\",\"link\":\"packlevelup.html\"},{\"image\":\"img/image 4.jpg\",\"title\":\"PACK ELEVATE\",\"subtitle_html\":\"Durée : 1 week-end\",\"link\":\"packelevate1.html\"},{\"image\":\"img/image 5.jpg\",\"title\":\"L’abonnement SO ELEVATE FLOW\",\"subtitle_html\":\"Durée : 3 séances<br>par semaine\",\"link\":\"soelevateflow1.html\"}]', '{\"contact\":{\"phone\":\"+33 7 68 77 04 51\",\"email\":\"sophie@so-elevate.com\",\"socials\":{\"facebook\":\"https://www.facebook.com/share/16wSK4g8Td/?mibextid=wwXIfr\",\"instagram\":\"https://www.instagram.com/so_elevate?igsh=bjc2czRlbG5sa3Uy\",\"linkedin\":\"https://fr.linkedin.com/in/sophie-barbet-2bb3a184\"}},\"credit_html\":\"Réalisé par <a href=\\\"mailto:contact@hldigital.fr\\\" target=\\\"_blank\\\" rel=\\\"noopener\\\">HL DIGITAL</a>\"}', '2025-09-23 16:24:07', '2025-10-01 22:16:52');

-- --------------------------------------------------------

--
-- Structure de la table `legal_imprint`
--

CREATE TABLE `legal_imprint` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `locale` varchar(10) NOT NULL DEFAULT 'fr',
  `version` varchar(50) DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `editor_name` varchar(190) NOT NULL,
  `editor_siret` varchar(32) DEFAULT NULL,
  `editor_email` varchar(190) DEFAULT NULL,
  `editor_phone` varchar(32) DEFAULT NULL,
  `hosting_provider` varchar(190) DEFAULT NULL,
  `publisher_name` varchar(190) DEFAULT NULL,
  `dev_agency` varchar(190) DEFAULT NULL,
  `dev_email` varchar(190) DEFAULT NULL,
  `dev_phone` varchar(32) DEFAULT NULL,
  `extras` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extras`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Déchargement des données de la table `legal_imprint`
--

INSERT INTO `legal_imprint` (`id`, `locale`, `version`, `effective_date`, `editor_name`, `editor_siret`, `editor_email`, `editor_phone`, `hosting_provider`, `publisher_name`, `dev_agency`, `dev_email`, `dev_phone`, `extras`, `created_at`, `updated_at`) VALUES
(1, 'fr', 'v2025-09-30', '2025-09-30', 'So ELEVATE', '[XXXXXXX]', 'sophie@so-elevate.com', '+33768770451', 'HOSTINGER', 'Sophie BARBET', 'HL Digital – Lynda HADDAD', 'contact@hldigital.fr', '+33687146250', NULL, '2025-10-05 12:42:28', '2025-10-05 12:42:28');

-- --------------------------------------------------------

--
-- Structure de la table `legal_sections`
--

CREATE TABLE `legal_sections` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `slug` varchar(100) NOT NULL,
  `section_key` varchar(100) NOT NULL,
  `title` varchar(255) NOT NULL,
  `body` longtext NOT NULL,
  `locale` varchar(10) NOT NULL DEFAULT 'fr',
  `version` varchar(50) DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Déchargement des données de la table `legal_sections`
--

INSERT INTO `legal_sections` (`id`, `slug`, `section_key`, `title`, `body`, `locale`, `version`, `effective_date`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'cgv', 'main', 'CONDITIONS GÉNÉRALES DE VENTE (CGV)', 'CONDITIONS GÉNÉRALES DE VENTE (CGV)\n\r\n1. Objet\n\r\nLes présentes Conditions Générales de Vente s’appliquent à l’ensemble des prestations proposées par « So Elevate » : accompagnements individuels, ateliers et événements collectifs, abonnements.\n\r\n2. Public concerné\n\r\nLes prestations s’adressent :\n\r\n• Aux particuliers (femmes majeures)\n\r\n• Aux entreprises dans le cadre d’événements, séminaires ou ateliers QVCT\n\r\n3. Prestations et formats\n\r\n• Séances individuelles : sur rendez-vous, en présentiel (domicile ou extérieur)\n\r\n• Packs / événements collectifs : dates imposées, en présentiel, durée définie\n\r\n• Abonnements : 2 à 4 séances par semaine, prélèvement mensuel\n\r\n4. Tarifs et paiement\n\r\n• Les tarifs sont exprimés en euros TTC.\n\r\n• Paiement en espèce, Paypal, par virement bancaire ou prélèvement automatique (abonnement).\n\r\n• La réservation d’une séance ou d’un événement est confirmé au versement d’un acompte, le solde devant être réglé avant le début de la prestation (hors abonnements réglés mensuellement).\n\r\n5. Annulation, report et remboursement (Particuliers)\n\r\n• L’acompte est conservé en cas d’annulation moins de 48h avant le rendez-vous ; au-delà de ce délai, un report reste possible.\n\r\n• Les abonnements sont sans engagement mais toute mensualité commencée est due.\n\r\n• En cas d’arrêt médical prolongé de la praticienne (maladie, accident, grossesse), les séances seront reportées ou remboursées au prorata.\n\r\n• En cas de congés de la praticienne, un planning de remplacement ou un ajustement sera proposé.\n\r\n6. Conditions spécifiques (Entreprises)\n\r\n• Les modalités d’annulation ou de report sont négociées au cas par cas, selon le contrat signé.\n\r\n7. Engagements du praticien\n\r\n• Les pratiques proposées ne se substituent pas à un suivi médical ou psychologique.\n\r\n• Le praticien s’engage à garantir confidentialité, bienveillance et professionnalisme.\n\r\n8. Engagements du client\n\r\n• Le client s’engage à fournir des informations sincères concernant sa santé.\n\r\n• Le client reconnaît être responsable de sa participation et de son état physique/psychique.\n\r\n9. Droit applicable\n\r\nLes présentes CGV sont soumises au droit français.', 'fr', 'v2025-09-30', '2025-09-30', 1, '2025-10-05 12:10:10', '2025-10-05 12:10:10'),
(2, 'privacy', 'main', 'POLITIQUE DE CONFIDENTIALITÉ', 'POLITIQUE DE CONFIDENTIALITÉ\n\r\nCollecte des données\n\r\nLors de la réservation, l’inscription à la newsletter ou la prise de contact, [So Elevate] collecte des données personnelles (nom, prénom, email, téléphone, informations de paiement).\n\r\nUtilisation des données\n\r\nLes données sont utilisées uniquement pour :\n\r\n• La gestion des rendez-vous et abonnements\n\r\n• La facturation\n\r\n• La communication d’informations liées aux prestations et aux actualités\n\r\nConservation des données\n\r\nLes données sont conservées pendant la durée de la relation contractuelle puis archivées pour une durée légale de 3 ans.\n\r\nDroits du client\n\r\nConformément au RGPD, tout client peut accéder, rectifier, demander la suppression ou la portabilité de ses données en écrivant à sophie@so-elevate.com.', 'fr', 'v2025-09-30', '2025-09-30', 2, '2025-10-05 12:10:10', '2025-10-05 12:10:10'),
(3, 'cancellation', 'summary', 'POLITIQUE DE REPORT / ANNULATION (Résumé simplifié pour affichage)', 'POLITIQUE DE REPORT / ANNULATION (Résumé simplifié pour affichage)\n\r\n• Particuliers : annulation < 48h = acompte perdu, report possible 1x/mois\n\r\n• Abonnement : mensualité due, résiliation possible à tout moment pour le mois suivant\n\r\n• Praticienne : congés/arrêt maladie/grossesse → report ou remboursement au prorata\n\r\n• Entreprises : conditions souples définies par contrat', 'fr', 'v2025-09-30', '2025-09-30', 3, '2025-10-05 12:10:10', '2025-10-05 12:10:10');

-- --------------------------------------------------------

--
-- Structure de la table `reservation`
--

CREATE TABLE `reservation` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `date_jour` date NOT NULL,
  `heure_txt` varchar(50) NOT NULL,
  `heure` varchar(50) NOT NULL,
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `is_master` tinyint(1) NOT NULL DEFAULT 0,
  `is_booked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `client_nom` varchar(160) DEFAULT NULL,
  `client_email` varchar(191) DEFAULT NULL,
  `client_tel` varchar(40) DEFAULT NULL,
  `reservation_status` enum('En attente','Confirmé','Terminé','Annulé') NOT NULL DEFAULT 'En attente',
  `payment_status` enum('En attente','Payé','Remboursé') NOT NULL DEFAULT 'En attente',
  `notes` text DEFAULT NULL,
  `capacity` int(10) UNSIGNED DEFAULT 1,
  `reserved_count` int(11) NOT NULL DEFAULT 0,
  `message` varchar(50) NOT NULL,
  `heure_key` varchar(100) GENERATED ALWAYS AS (lcase(trim(coalesce(`heure`,`heure_txt`)))) STORED,
  `master_flag` tinyint(1) GENERATED ALWAYS AS (case when `client_email` is null and `client_tel` is null then 1 else 0 end) STORED
) ;

--
-- Déchargement des données de la table `reservation`
--

INSERT INTO `reservation` (`id`, `date_jour`, `heure_txt`, `heure`, `service_id`, `is_open`, `is_master`, `is_booked`, `created_at`, `updated_at`, `client_nom`, `client_email`, `client_tel`, `reservation_status`, `payment_status`, `notes`, `capacity`, `reserved_count`, `message`) VALUES
(82, '2025-10-07', '10h', '10h', 1, 0, 0, 0, '2025-10-07 10:08:24', '2025-10-07 10:10:25', NULL, NULL, NULL, 'Confirmé', 'Payé', NULL, 3, 2, '');

--
-- Déclencheurs `reservation`
--
DELIMITER $$
CREATE TRIGGER `trg_reservation_bi` BEFORE INSERT ON `reservation` FOR EACH ROW BEGIN
  /* conserve ta logique existante heure_key */
  SET NEW.heure_key = LOWER(TRIM(COALESCE(NEW.heure, NEW.heure_txt, '')));

  /* hygiène champs */
  IF NEW.capacity IS NULL OR NEW.capacity < 0 THEN SET NEW.capacity = 0; END IF;
  SET NEW.is_open   = COALESCE(NEW.is_open,   1);
  SET NEW.is_booked = COALESCE(NEW.is_booked, 0);

  /* ✅ correctif critique : ne jamais laisser NULL */
  SET NEW.reserved_count = COALESCE(NEW.reserved_count,
                                    CASE WHEN NEW.is_booked = 1 THEN 1 ELSE 0 END,
                                    0);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_reservation_bu` BEFORE UPDATE ON `reservation` FOR EACH ROW BEGIN
  IF NEW.capacity < 0 THEN SET NEW.capacity = 0; END IF;

  /* ✅ correctif critique sur UPDATE aussi */
  SET NEW.reserved_count = COALESCE(NEW.reserved_count,
                                    CASE WHEN NEW.is_booked = 1 THEN 1 ELSE 0 END,
                                    0);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `reservation_clients`
--

CREATE TABLE `reservation_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reservation_id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `tel` varchar(50) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `status` enum('En attente','Confirmé','Annulé') DEFAULT 'En attente',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `reservation_clients`
--

INSERT INTO `reservation_clients` (`id`, `reservation_id`, `nom`, `email`, `tel`, `message`, `status`, `created_at`) VALUES
(18, 82, 'jhjhhjhhj hhhhh', 'gghghgh@gmail.com', '454444664', 'gggghghhggh', 'Confirmé', '2025-10-07 10:09:22'),
(19, 82, 'hhghggh ghhgghhg', 'ghghghg@gmail.com', '545456556', 'ghghghhghhgg', 'Confirmé', '2025-10-07 10:10:25');

-- --------------------------------------------------------

--
-- Structure de la table `reserver`
--

CREATE TABLE `reserver` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reservation_id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `date_jour` date NOT NULL,
  `heure` varchar(50) NOT NULL,
  `client_prenom` varchar(80) NOT NULL,
  `client_nom` varchar(120) NOT NULL,
  `client_email` varchar(191) NOT NULL,
  `client_tel` varchar(64) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `status` enum('En attente','Confirmé','Annulé','Terminé') NOT NULL DEFAULT 'En attente',
  `payment_status` enum('Non payé','En attente','Payé','Remboursé') NOT NULL DEFAULT 'Non payé',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déclencheurs `reserver`
--
DELIMITER $$
CREATE TRIGGER `trg_reserver_ad` AFTER DELETE ON `reserver` FOR EACH ROW BEGIN
  CALL sp_resa_recompute(OLD.reservation_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_reserver_ai` AFTER INSERT ON `reserver` FOR EACH ROW BEGIN
  CALL sp_resa_recompute(NEW.reservation_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_reserver_au` AFTER UPDATE ON `reserver` FOR EACH ROW BEGIN
  -- Ne recalcule que si réservation liée ou statut pertinent a changé
  IF NEW.reservation_id <> OLD.reservation_id
     OR NEW.status <> OLD.status THEN
    CALL sp_resa_recompute(NEW.reservation_id);
    IF NEW.reservation_id <> OLD.reservation_id THEN
      CALL sp_resa_recompute(OLD.reservation_id);
    END IF;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `services`
--

CREATE TABLE `services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `label` varchar(160) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `services`
--

INSERT INTO `services` (`id`, `label`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'SO ELEVATE FOR YOU ', 1, '2025-09-23 13:02:26', '2025-10-04 00:40:43'),
(2, 'PACK RESET ', 1, '2025-09-23 13:02:26', '2025-10-04 00:40:53'),
(3, 'PACK LEVEL UP ', 1, '2025-09-23 13:02:26', '2025-10-04 00:41:02'),
(4, 'PACK ELEVATE ', 1, '2025-09-23 13:02:26', '2025-10-04 00:41:11'),
(5, ' SO ELEVATE FLOW', 1, '2025-09-23 13:02:26', '2025-10-04 00:42:54');

-- --------------------------------------------------------

--
-- Structure de la table `site_content`
--

CREATE TABLE `site_content` (
  `id` int(10) UNSIGNED NOT NULL,
  `site_name` varchar(100) NOT NULL,
  `colors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`colors`)),
  `assets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`assets`)),
  `navbar` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`navbar`)),
  `hero` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`hero`)),
  `about` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`about`)),
  `features_intro` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`features_intro`)),
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`features`)),
  `method_cta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`method_cta`)),
  `ocean` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`ocean`)),
  `testimonials` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`testimonials`)),
  `cta_section` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`cta_section`)),
  `footer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`footer`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `about_full` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`about_full`)),
  `techniques_full` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`techniques_full`)),
  `methode` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`methode`)),
  `methode_assets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`methode_assets`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `site_content`
--

INSERT INTO `site_content` (`id`, `site_name`, `colors`, `assets`, `navbar`, `hero`, `about`, `features_intro`, `features`, `method_cta`, `ocean`, `testimonials`, `cta_section`, `footer`, `created_at`, `updated_at`, `about_full`, `techniques_full`, `methode`, `methode_assets`) VALUES
(1, 'SO ELEVATE', '{\"nav_h_desktop\":\"72px\",\"nav_h_mobile\":\"64px\",\"brand_green\":\"#1f6a60\",\"text_dark\":\"#3a3a3a\",\"gold\":\"#d6b68a\",\"sep_underline\":\"rgba(0,0,0,.14)\"}', '{\"logo\":\"img/logo 1.png\",\"bling_footer\":\"img/footer.jpg\",\"features_bg\":\"img/plage.jpg\",\"testimonials_bg\":\"img/artemoignage.jpg\",\"ocean_bg\":\"img/arriereplan.jpg\",\"portrait_bg\":\"img/sophie_.jpg\"}', '{\"brand\":\"SO ELEVATE\",\"menu\":[{\"label\":\"Qui je suis\",\"link\":\"qui-je-suis.php\"},{\"label\":\"Ma méthode\",\"link\":\"ma-methode.php\"},{\"label\":\"Accompagnements\",\"link\":\"accompagnement.php\"},{\"label\":\"Entreprises\",\"link\":\"entreprise.php\"},{\"label\":\"Contact\",\"link\":\"contact.php\"}],\"reserve\":{\"label\":\"Réserver\",\"link\":\"formulaire.php\"}}', '{\"title\":\"Passez au niveau supérieur\",\"subtitle\":\"Vous avez l’impression de passer à côté de votre vie ?\",\"text\":\"Retrouvez qui vous êtes vraiment et choisissez la vie qui vous ressemble.\",\"cta\":{\"text\":\"Je réserve ma séance\",\"link\":\"formulaire.php\"},\"video\":{\"src\":\"img/video.mp4\",\"poster\":\"assets/hero-poster.jpg\"}}', '{\"title\":\"Qui je suis ?\",\"image\":\"img/sophie_.jpg\",\"paragraphs\":[\"Je m’appelle Sophie et j’ai choisi d’accompagner les particuliers comme les entreprises qui souhaitent transformer leur énergie et retrouver un équilibre profond. Ma mission est de créer des expériences qui réveillent le corps, apaisent l’esprit et ouvrent un espace de reconnexion intérieure.\\r\\n\\r\\nJ’aime guider chacun, individuellement ou en collectif, à franchir ce pas vers plus de clarté, de vitalité et de confiance en soi.\",\"J’aime guider chacun, individuellement ou en collectif, à franchir ce pas vers plus de clarté, de vitalité et de confiance en soi.\"],\"cta\":{\"text\":\"En lire plus\",\"link\":\"quisuisje.html\"}}', '{\"title\":\"Une approche multi sensorielle\",\"text\":\"Une approche active, fondée sur des pratiques sensorielles qui réveillent le corps, apaisent le mental, libèrent les émotions et installent une énergie durable — pour retrouver votre sérénité et vous sentir pleinement vivante.\"}', '[{\"icon\":\"img/brainflow.png\",\"title\":\"Breath Flow\",\"subtitle\":\"Techniques de respiration\"},{\"icon\":\"img/mindfocus.png\",\"title\":\"Mind Focus\",\"subtitle\":\"Techniques de méditation\"},{\"icon\":\"img/sound.png\",\"title\":\"Sound activation\",\"subtitle\":\"Techniques de sonothérapie\"},{\"icon\":\"img/barefoot.png\",\"title\":\"Barefoot Awakening\",\"subtitle\":\"Techniques d’ancrage\"},{\"icon\":\"img/bodysince.png\",\"title\":\"Body sense\",\"subtitle\":\"Techniques de massage\"},{\"icon\":\"img/coldsince.png\",\"title\":\"Cold boost\",\"subtitle\":\"Techniques d’exposition au froid\"}]', '[]', '{\"title_html\":\"Votre<br/>chemin <br/>commence ici<br/>\",\"text_html\":\"Que vous soyez un <strong>particulier</strong> ou une <strong>entreprise</strong>, choisissez l’accompagnement qui vous correspond.\",\"background\":\"img/arriereplan.jpg\",\"cards\":[{\"title\":\"Particuliers\",\"link\":\"accompagnement.php\",\"style\":\"warm\"},{\"title\":\"Professionnels\",\"link\":\"entreprise.php\",\"style\":\"cool\"}]}', '{\"title\":\"Ils en parlent mieux que moi\",\"background\":\"img/artemoignage.jpg\",\"items\":[\"Je suis arrivée vidée, dispersée et déconnectée de moi-même. En quelques séances, j’ai retrouvé une énergie que je croyais perdue. Merci Sophie !\",\"Une expérience unique. J’ai appris à écouter mon corps et à calmer mon mental. Les effets se ressentent au quotidien.\",\"Bienveillance, précision et résultats concrets. Je me sens plus centrée et sereine dans mon travail comme à la maison.\",\"J’ai retrouvé le sommeil et une clarté d’esprit que je n’avais plus depuis longtemps. Un grand merci !\",\"Des séances douces et puissantes à la fois. Je repars à chaque fois avec de l’élan et des clés simples à appliquer.\"]}', '{\"title_html\":\"Es-tu prête à transformer ton énergie et à franchir enfin ce pas vers plus de clarté, de vitalité et de sérénité&nbsp;?\",\"text_html\":\"<strong>Le changement</strong> commence toujours par une décision simple. <strong>Ose ce premier pas</strong> : je suis là pour <strong>t’accompagner</strong>, <strong>t’écouter</strong> et <strong>t’aider</strong> à trouver l’accompagnement qui te correspond vraiment.\",\"buttons\":[{\"text\":\"Je fais le premier pas\",\"link\":\"formulaire.php\"},{\"text\":\"Planifier un appel gratuit\",\"link\":\"tel:+33662480433\"}],\"title\":\"\",\"text\":\"\"}', '{\"phone\":\"+33 7 68 77 04 51\",\"email\":\"sophie@so-elevate.com\",\"socials\":{\"facebook\":\"https://www.facebook.com/share/16wSK4g8Td/?mibextid=wwXIfr\",\"instagram\":\"https://www.instagram.com/so_elevate?igsh=bjc2czRlbG5sa3Uy\",\"linkedin\":\"https://fr.linkedin.com/in/sophie-barbet-2bb3a184\"},\"menu\":[{\"label\":\"Qui je suis ?\",\"link\":\"qui-je-suis.php\"},{\"label\":\"Ma méthode\",\"link\":\"ma-methode.php\"},{\"label\":\"Accompagnements\",\"link\":\"accompagnement.php\"},{\"label\":\"Entreprises\",\"link\":\"entreprise.php\"},{\"label\":\"Contact\",\"link\":\"contact.php\"},{\"label\":\"Réserver\",\"link\":\"formulaire.php\"}],\"resources\":[{\"label\":\"CGV\",\"link\":\"cgv.php\"},{\"label\":\"Mentions légales\",\"link\":\"mentions-legales.php\"}],\"credit_html\":\"Réalisé par <a href=\\\"mailto:contact@hldigital.fr\\\" target=\\\"_blank\\\" rel=\\\"noopener\\\">HL DIGITAL | Développement web</a>\"}', '2025-09-15 23:57:22', '2025-10-06 00:35:13', '{\"page\":{\"slug\":\"quisuisje.html\",\"title\":\"SO ELEVATE — Qui je suis ?\",\"meta\":{\"charset\":\"utf-8\",\"viewport\":\"width=device-width, initial-scale=1\"},\"assets\":{\"brand_logo\":\"img/logo 1.png\",\"about_bg\":\"img/sophie.svg\",\"bling_footer\":\"img/footer.jpg\"},\"navbar\":{\"menu\":[{\"label\":\"Qui je suis\",\"href\":\"quisuisje.html\",\"active\":true},{\"label\":\"Ma méthode\",\"href\":\"methode.html\"},{\"label\":\"Accompagnements\",\"href\":\"accompagnement.html\"},{\"label\":\"Entreprises\",\"href\":\"entreprise.html\"},{\"label\":\"Contact\",\"href\":\"contact.php\"}],\"cta\":{\"label\":\"Réserver\",\"href\":\"formulaire.html\"}},\"lead\":{\"html\":\"<p><strong>À propos de Sophie – Votre coach en développement personnel</strong></p>\"},\"sections\":[{\"type\":\"paragraph\",\"html\":\"<p>Je suis Sophie, thérapeute spécialisée dans la transformation intérieure par l’expérience sensorielle. Pendant longtemps, j’ai porté le masque de la femme forte : disponible, efficace, capable de tout tenir malgré la fatigue et le stress. Mais derrière ce masque, je me suis rendu compte que je passais à côté de ma vie, de mes désirs et de mes émotions. Un jour, j’ai décidé d’arrêter de survivre. J’ai écouté mon corps, suivi mon intuition, et réappris à respirer, à ressentir et me redécouvrir. Ce chemin a transformé ma vie et m’inspire aujourd’hui à guider d’autres femmes vers la même liberté.</p>\"},{\"type\":\"heading\",\"title\":\"Ma mission\"},{\"type\":\"paragraph\",\"html\":\"<p>Aider les femmes et les équipes à dépasser le stress, la perte de repères et la fatigue en activant leurs cinq sens. Avec une approche professionnelle, structurée et profondément humaine, je vous accompagne vers plus d’assurance, de motivation et de sérénité.</p>\"},{\"type\":\"paragraph\",\"html\":\"<p><em>Phrase signature :</em> <strong>Parce que retrouver du sens, c’est retrouver de la puissance.</strong></p>\"},{\"type\":\"heading\",\"title\":\"Mon approche\"},{\"type\":\"paragraph\",\"html\":\"<p>Je ne propose pas de méthode figée, mais des expériences vivantes et personnalisées, adaptées à qui vous êtes ici et maintenant.</p>\"},{\"type\":\"list\",\"title\":\"Mon approche\",\"items\":[\"Activation des 5 sens pour reconnecter au présent\",\"Exercices pratiques et immersifs qui ancrent des changements durables\",\"Cadre bienveillant et concret pour transformer l’expérience en véritable moteur de croissance\"]},{\"type\":\"heading\",\"title\":\"Pour les femmes – BtoC\"},{\"type\":\"paragraph\",\"html\":\"<p><strong>Explorer, réactiver, retrouver</strong> — Chaque séance est conçue pour :</p>\"},{\"type\":\"list\",\"title\":\"Pour les femmes – BtoC\",\"items\":[\"Explorer vos peurs infondées, croyances limitantes et blocages, et réactiver vos ressources\",\"Retrouver confiance en vous et un équilibre dans votre vie de femme\",\"Vivre une expérience sensorielle individuelle et/ou partagée\",\"Développer des outils concrets pour votre quotidien\"]},{\"type\":\"paragraph\",\"html\":\"<p>Mon travail combine le coaching transformationnel et les pratiques sensorielles. Chaque séance est un moment de bien-être pour vous, car prendre soin de soi n’est pas un luxe, c’est une nécessité.</p>\"},{\"type\":\"paragraph\",\"html\":\"<p><strong>Mon engagement :</strong> Créer un espace vivant et sensoriel où vous pouvez vous redevenir vous-même, une femme, pour vivre pleinement votre vie et passer au niveau supérieur.</p>\"},{\"type\":\"heading\",\"title\":\"Pour les entreprises – BtoB\"},{\"type\":\"paragraph\",\"html\":\"<p><strong>Bien-être et performance en entreprise</strong></p>\"},{\"type\":\"paragraph\",\"html\":\"<p>Des expériences sensorielles pour une QVCT durable : mes programmes combinent pratiques sensorielles et accompagnement actif pour renforcer la cohésion d’équipe, stimuler l’énergie et booster la performance collective.</p>\"},{\"type\":\"paragraph\",\"html\":\"<p><strong>Ateliers bien-être et cohésion d’équipe</strong> — Des sessions collectives conçues pour :</p>\"},{\"type\":\"list\",\"title\":\"Ateliers bien-être et cohésion d’équipe\",\"items\":[\"Renforcer l’engagement et la motivation des collaborateurs\",\"Réduire le stress et améliorer la résilience\",\"Stimuler la créativité et la collaboration à travers des expériences sensorielles immersives\"]},{\"type\":\"paragraph\",\"html\":\"<p><strong>Programmes sur mesure</strong> — adaptés à vos objectifs :</p>\"},{\"type\":\"list\",\"title\":\"Programmes sur mesure\",\"items\":[\"Motivation et engagement des équipes\",\"Gestion du stress et prévention du burn-out\",\"Qualité de vie au travail et équilibre vie pro/perso\",\"Renforcement de la cohésion et de la collaboration\"]},{\"type\":\"paragraph\",\"html\":\"<p>Votre programme peut combiner des ateliers collectifs, des séances individuelles et un suivi pour un impact durable.</p>\"},{\"type\":\"heading\",\"title\":\"Pourquoi choisir So Elevate\"},{\"type\":\"list\",\"title\":\"Pourquoi choisir So Elevate\",\"items\":[\"Une approche active et sensorielle, unique sur le marché\",\"Des solutions personnalisées pour maximiser l’impact sur vos équipes\",\"Une expertise reconnue dans la transformation intérieure et la régulation du stress\",\"Des ateliers et programmes conçus pour être plaisants, engageants et productifs\"]},{\"type\":\"heading\",\"title\":\"Contact – Prêt·e à passer au niveau supérieur ?\"},{\"type\":\"paragraph\",\"html\":\"<p>Que vous soyez une femme en quête de clarté ou une entreprise souhaitant investir dans le bien-être de ses équipes, je serai ravie d’échanger avec vous.</p>\"}],\"actions\":[{\"label\":\"écrit moi\",\"href\":\"mailto:sophie@so-elevate.com\",\"kind\":\"email\"},{\"label\":\"Planifier un appel\",\"href\":\"https://wa.me/33768770451\",\"kind\":\"whatsapp\"}],\"contacts\":[{\"kind\":\"phone\",\"display\":\"+33 7 68 77 04 51\",\"href\":\"tel:+33662480433\"},{\"kind\":\"email\",\"display\":\"sophie@so-elevate.com\",\"href\":\"mailto:sophie@so-elevate.com\"}],\"socials\":{\"facebook\":\"https://www.facebook.com/share/16wSK4g8Td/?mibextid=wwXIfr\",\"instagram\":\"https://www.instagram.com/so_elevate?igsh=bjc2czRlbG5sa3Uy\",\"linkedin\":\"https://fr.linkedin.com/in/sophie-barbet-2bb3a184\"},\"footer\":{\"menu\":[{\"label\":\"Qui je suis ?\",\"href\":\"quisuisje.html\"},{\"label\":\"Ma méthode\",\"href\":\"methode.html\"},{\"label\":\"Accompagnements\",\"href\":\"accompagnement.html\"},{\"label\":\"Entreprises\",\"href\":\"entreprise.html\"},{\"label\":\"Contact\",\"href\":\"contact.html\"},{\"label\":\"Réserver\",\"href\":\"reservation.html\"}],\"resources\":[{\"label\":\"CGV\",\"href\":\"cgv.html\"},{\"label\":\"Politique de confidentialité\",\"href\":\"confidentialite.html\"},{\"label\":\"Mentions légales\",\"href\":\"mentions-legales.html\"}],\"credit_html\":\"Réalisé par <a href=\\\"mailto:contact@hldigital.fr\\\">HL DIGITAL| Développement web  </a>\"}}}', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `soelevate`
--

CREATE TABLE `soelevate` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `slug` varchar(120) NOT NULL,
  `locale` varchar(10) NOT NULL DEFAULT 'fr',
  `version` varchar(50) DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `html_title` varchar(255) NOT NULL,
  `page_title` varchar(255) NOT NULL,
  `subtitle` varchar(255) NOT NULL,
  `includes_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`includes_json`)),
  `price_single_text` varchar(190) NOT NULL,
  `price_pack_text` varchar(190) NOT NULL,
  `advice_text` text NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `image_alt` varchar(255) NOT NULL,
  `image_mime` varchar(100) DEFAULT NULL,
  `image_blob` longblob DEFAULT NULL,
  `cta_primary_label` varchar(120) NOT NULL,
  `cta_primary_url` varchar(255) NOT NULL,
  `cta_secondary_label` varchar(120) NOT NULL,
  `cta_secondary_url` varchar(255) NOT NULL,
  `extras` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extras`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `soelevate`
--

INSERT INTO `soelevate` (`id`, `slug`, `locale`, `version`, `effective_date`, `html_title`, `page_title`, `subtitle`, `includes_json`, `price_single_text`, `price_pack_text`, `advice_text`, `image_path`, `image_alt`, `image_mime`, `image_blob`, `cta_primary_label`, `cta_primary_url`, `cta_secondary_label`, `cta_secondary_url`, `extras`, `created_at`, `updated_at`) VALUES
(1, 'so-elevate-for-you', 'fr', 'v2025-09-30', '2025-09-30', 'SO ELEVATE FOR YOU', 'SO ELEVATE FOR YOU', 'Séance individuelle – 1h', '[\"1 exercice de respiration\",\"1 exercice de méditation\",\"1 exercice au choix parmi les autres techniques\"]', '80', '', '', 'img/image 1.jpg', 'SO ELEVATE FOR YOU', 'image/jpeg', NULL, 'Réserver', 'reservation.php', 'Formule suivante', 'packreset.php', '{\"brand_green\": \"#1f6a60\", \"gold\": \"#d6b68a\", \"grey\": \"#5A5A5A\"}', '2025-10-05 20:10:35', '2025-10-05 21:07:00');

-- --------------------------------------------------------

--
-- Structure de la table `techniques_page`
--

CREATE TABLE `techniques_page` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `intro` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`intro`)),
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`items`)),
  `benefits` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`benefits`)),
  `footer_links` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`footer_links`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `techniques_page`
--

INSERT INTO `techniques_page` (`id`, `intro`, `items`, `benefits`, `footer_links`, `created_at`, `updated_at`) VALUES
(1, '{\"title\":\"Mes techniques d’accompagnement\",\"lead_html\":\"Dans mes séances, j’utilise différentes approches complémentaires issues des pratiques de bien-être et de développement personnel. J’associe plusieurs outils pour créer une expérience sensorielle complète. Les techniques que je propose sont :\"}', '[{\"key\":\"breath_flow\",\"icon\":\"img/1.png\",\"title\":\"Breath Flow\",\"subtitle\":\"Techniques de respiration\",\"desc\":\"Des exercices structurés pour explorer la puissance du souffle et son impact sur l’équilibre intérieur, par exemple :\",\"bullets\":[\"respiration 4-4-8\",\"cohérence cardiaque\",\"respiration carrée (4-4-4-4)\",\"respiration alternée (Nadi Shodhana)\",\"respiration consciente avec rétention (Wim Hof)\",\"respiration rythmée sur le mouvement\"]},{\"key\":\"mind_focus\",\"icon\":\"img/2.png\",\"title\":\"Mind Focus\",\"subtitle\":\"Techniques de méditation\",\"desc\":\"Des temps d’attention et de présence dirigée qui favorisent l’exploration de l’esprit et la reconnexion à soi, par exemple :\",\"bullets\":[\"visualisation (lieu ressource, objectif, lumière intérieure)\",\"scan corporel\",\"méditation sur le souffle (anapanasati)\",\"méditation sur un son répété (mantra / vibration)\",\"méditation des 5 sens\",\"méditation en mouvement (lente, marche silencieuse…)\"]},{\"key\":\"sound_activation\",\"icon\":\"img/3.png\",\"title\":\"Sound activation\",\"subtitle\":\"Techniques de sonothérapie\",\"desc\":\"L’utilisation des sons pour inviter à la concentration et à l’apaisement, par exemple :\",\"bullets\":[\"bols tibétains & bols en cristal\",\"gong bath\",\"carillons koshi\",\"tambour chamanique\",\"fréquences binaurales / isochroniques\",\"ASMR\"]},{\"key\":\"barefoot_awakening\",\"icon\":\"img/4.png\",\"title\":\"Barefoot Awakening\",\"subtitle\":\"Techniques d’ancrage\",\"desc\":\"Un retour aux sensations directes de contact avec le sol, sur un parcours adapté avec segmentation des sens :\",\"bullets\":[\"marcher sur différents terrains (sable, herbe, terre, galets, bois)\",\"alterner marche lente et marche dynamique pieds nus\",\"marcher en synchronisation avec un groupe\",\"ancrage statique : ressentir le sol sous chaque partie du pied\"]},{\"key\":\"body_sense\",\"icon\":\"img/5.png\",\"title\":\"Body sense\",\"subtitle\":\"Techniques de massage\",\"desc\":\"Des gestes simples et accessibles pour redécouvrir son corps et en prendre soin. Exemples :\",\"bullets\":[\"Foot roll massage : libération plantaire avec une balle\",\"Body Tapping : tapotement énergique\",\"Neck tension release : relâcher épaules/nuque\",\"Glide : lisser bras et jambes du haut vers le bas\",\"Deep Roll : poings roulants sur cuisses/bas du dos\",\"Head flow : stimulation crânienne\"]},{\"key\":\"cold_boost\",\"icon\":\"img/6.png\",\"title\":\"Cold boost\",\"subtitle\":\"Techniques d’exposition au froid\",\"desc\":\"Un travail progressif de mise en contact avec le froid, outil de dépassement et de renforcement mental. Exemples :\",\"bullets\":[\"marche pieds nus dans l’herbe sur la rosée du matin\",\"immersion visage / mains / pieds dans de l’eau glacée\",\"exposition statique au vent en tenue légère\",\"bain froid (mer, lac ou rivière) < 12°C\"]}]', '{\"title\":\"Bienfaits de l’expérience sensorielle\",\"lead_html\":[\"Ce n’est pas juste “se détendre”. Chaque séance So Elevate stimule le corps et l’esprit de manière complète et harmonieuse. Dans notre vie moderne, le corps est souvent “désactivé” : climatisation, chauffage, pollution, stress permanent ou médicaments peuvent l’empêcher de fonctionner pleinement.\",\"Ces séances sont une invitation à reconnecter avec ton corps, à sortir de ta zone de confort sensorielle et à lui laisser reprendre son rôle naturel : celui de te protéger, de réguler ton énergie, et de te maintenir en équilibre. Voici ce que tu peux ressentir après chaque session :\"],\"cards\":[{\"image\":\"img/image4.jpg\",\"title\":\"Bienfaits physiques\",\"items\":[\"Sommeil plus profond et récupération améliorée\",\"Respiration plus ample, meilleure oxygénation\",\"Diminution des tensions musculaires et gain de mobilité\",\"Circulation sanguine stimulée et énergie plus stable\",\"Réduction des douleurs liées au stress et aux postures\"]},{\"image\":\"img/image6.jpg\",\"title\":\"Bienfaits cognitifs et émotionnels\",\"items\":[\"Clarté mentale, concentration et créativité\",\"Apaisement du stress et de l’anxiété\",\"Régulation émotionnelle et sentiment d’ancrage\",\"Confiance en soi et sensation de présence au corps\",\"Humeur plus stable et positive\"]},{\"image\":\"img/image 7.jpg\",\"title\":\"Bienfaits immunitaires et métaboliques\",\"items\":[\"Stimulation du système immunitaire et de la variabilité cardiaque\",\"Meilleure tolérance au froid et résilience au stress\",\"Activation du métabolisme et régulation du système nerveux\",\"Équilibre hormonal et récupération plus rapide\",\"Capacité accrue à revenir à l’équilibre (homeostasie)\"]}]}', '{\"menu\": [{\"label\": \"Qui je suis ?\", \"link\": \"quisuisje.html\"}, {\"label\": \"Ma méthode\", \"link\": \"methode.html\"}, {\"label\": \"Accompagnements\", \"link\": \"accompagnement.html\"}, {\"label\": \"Entreprises\", \"link\": \"entreprise.html\"}, {\"label\": \"Contact\", \"link\": \"contact.html\"}, {\"label\": \"Réserver\", \"link\": \"reservation.html\"}], \"resources\": [{\"label\": \"CGV\", \"link\": \"cgv.html\"}, {\"label\": \"Politique de confidentialité\", \"link\": \"confidentialite.html\"}, {\"label\": \"Mentions légales\", \"link\": \"mentions-legales.html\"}], \"contact\": {\"phone\": \"+33768770451\", \"email\": \"sophie@so-elevate.com\", \"socials\": {\"facebook\": \"https://www.facebook.com/share/16wSK4g8Td/?mibextid=wwXIfr\", \"instagram\": \"https://www.instagram.com/so_elevate?igsh=bjc2czRlbG5sa3Uy\", \"linkedin\": \"https://fr.linkedin.com/in/sophie-barbet-2bb3a184\"}}, \"credit_html\": \"Réalisé par <a href=\\\"mailto:contact@hldigital.fr\\\" target=\\\"_blank\\\" rel=\\\"noopener\\\">HL Digital</a>\"}', '2025-09-23 15:25:16', '2025-10-05 13:37:22');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_reservation_stats`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_reservation_stats` (
`id` bigint(20) unsigned
,`date_jour` date
,`heure_aff` varchar(50)
,`service_id` bigint(20) unsigned
,`capacity` int(10) unsigned
,`reserved_count` int(11)
,`remaining` bigint(11) unsigned
,`is_open` tinyint(1)
);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `administrateurs`
--
ALTER TABLE `administrateurs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_administrateurs_email` (`email`);

--
-- Index pour la table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_status` (`status`);

--
-- Index pour la table `contact_page`
--
ALTER TABLE `contact_page`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `demandes_entreprise`
--
ALTER TABLE `demandes_entreprise`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_email` (`email`);

--
-- Index pour la table `entreprises_page`
--
ALTER TABLE `entreprises_page`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `formules_page`
--
ALTER TABLE `formules_page`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `legal_imprint`
--
ALTER TABLE `legal_imprint`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_legal_imprint_locale` (`locale`),
  ADD KEY `idx_legal_imprint_version` (`version`),
  ADD KEY `idx_legal_imprint_effective` (`effective_date`);

--
-- Index pour la table `legal_sections`
--
ALTER TABLE `legal_sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_legal_sections_slug` (`slug`),
  ADD KEY `idx_legal_sections_locale` (`locale`),
  ADD KEY `idx_legal_sections_version` (`version`);

--
-- Index pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_resa_date` (`date_jour`),
  ADD KEY `idx_resa_open` (`is_open`),
  ADD KEY `idx_resa_service` (`service_id`),
  ADD KEY `idx_reservation_service` (`service_id`),
  ADD KEY `idx_reservation_date` (`date_jour`),
  ADD KEY `idx_reservation_status` (`reservation_status`),
  ADD KEY `idx_payment_status` (`payment_status`);

--
-- Index pour la table `reservation_clients`
--
ALTER TABLE `reservation_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_reservation_clients_reservation` (`reservation_id`);

--
-- Index pour la table `reserver`
--
ALTER TABLE `reserver`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_reserver_slot_email` (`reservation_id`,`client_email`),
  ADD KEY `idx_reserver_resa` (`reservation_id`),
  ADD KEY `idx_reserver_service` (`service_id`),
  ADD KEY `idx_reserver_email` (`client_email`);

--
-- Index pour la table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_services_label` (`label`);

--
-- Index pour la table `site_content`
--
ALTER TABLE `site_content`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `soelevate`
--
ALTER TABLE `soelevate`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_soelevate_slug_locale` (`slug`,`locale`),
  ADD KEY `idx_soelevate_effective` (`effective_date`);

--
-- Index pour la table `techniques_page`
--
ALTER TABLE `techniques_page`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `administrateurs`
--
ALTER TABLE `administrateurs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `demandes_entreprise`
--
ALTER TABLE `demandes_entreprise`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `legal_imprint`
--
ALTER TABLE `legal_imprint`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `legal_sections`
--
ALTER TABLE `legal_sections`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `reservation_clients`
--
ALTER TABLE `reservation_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `reserver`
--
ALTER TABLE `reserver`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `services`
--
ALTER TABLE `services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=788;

--
-- AUTO_INCREMENT pour la table `site_content`
--
ALTER TABLE `site_content`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `soelevate`
--
ALTER TABLE `soelevate`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

-- --------------------------------------------------------

--
-- Structure de la vue `v_reservation_stats`
--
DROP TABLE IF EXISTS `v_reservation_stats`;

CREATE ALGORITHM=UNDEFINED DEFINER=`u416167129_soelevate25dm`@`127.0.0.1` SQL SECURITY DEFINER VIEW `v_reservation_stats`  AS SELECT `r`.`id` AS `id`, `r`.`date_jour` AS `date_jour`, coalesce(`r`.`heure`,`r`.`heure_txt`) AS `heure_aff`, `r`.`service_id` AS `service_id`, `r`.`capacity` AS `capacity`, `r`.`reserved_count` AS `reserved_count`, `r`.`capacity`- `r`.`reserved_count` AS `remaining`, `r`.`is_open` AS `is_open` FROM `reservation` AS `r` ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `fk_reservation_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `reservation_clients`
--
ALTER TABLE `reservation_clients`
  ADD CONSTRAINT `fk_reservation_clients_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `reserver`
--
ALTER TABLE `reserver`
  ADD CONSTRAINT `fk_reserver_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reserver_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
