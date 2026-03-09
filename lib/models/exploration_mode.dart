// lib/models/exploration_mode.dart

enum ExplorationMode {
  street,
  city,
  country,
  world;

  String get displayName {
    switch (this) {
      case ExplorationMode.street:
        return 'Street';
      case ExplorationMode.city:
        return 'City';
      case ExplorationMode.country:
        return 'Country';
      case ExplorationMode.world:
        return 'World';
    }
  }

  String get description {
    switch (this) {
      case ExplorationMode.street:
        return 'Explore a 5 km radius around a street';
      case ExplorationMode.city:
        return 'Discover your entire city';
      case ExplorationMode.country:
        return 'Uncover an entire country';
      case ExplorationMode.world:
        return 'Explore every corner of the planet';
    }
  }

  String get iconAsset {
    switch (this) {
      case ExplorationMode.street:
        return '🛤';
      case ExplorationMode.city:
        return '🏙';
      case ExplorationMode.country:
        return '🗺';
      case ExplorationMode.world:
        return '🌍';
    }
  }
}
