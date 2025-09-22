enum Flavor {
  prod,
  staging,
  dev,
}

class FlavorUtils {
  factory FlavorUtils() {
    return _instance;
  }

  FlavorUtils._internal();

  String baseUrl = "";

  static final FlavorUtils _instance = FlavorUtils._internal();

  late Flavor _flavor;

  void setFlavor(String flavor) {
    switch (flavor) {
      case 'prod':
        _flavor = Flavor.prod;
        break;
      case "staging":
        _flavor = Flavor.staging;
        break;
      case "dev":
        _flavor = Flavor.dev;
        break;
    }
  }

  Flavor get flavor {
    return _flavor;
  }

  bool get isProd {
    return _flavor == Flavor.prod;
  }

  bool get isStaging {
    return _flavor == Flavor.staging;
  }

  bool get isDev {
    return _flavor == Flavor.dev;
  }
}
