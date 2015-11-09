function findModelByProperty(type, property, value) {
  return type.all().toArray().findBy(property, value);
}

export default {
  findModelByProperty: findModelByProperty
};
