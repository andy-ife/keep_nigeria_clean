enum FilterType {
  nearest('Nearest bins'),
  emptiest('Emptiest bins'),
  lowOdor('Low odor bins');

  final String name;
  const FilterType(this.name);
}
