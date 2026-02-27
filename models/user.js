'use strict';

module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {

    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },

    name: DataTypes.STRING,
    email: DataTypes.STRING,
    password: DataTypes.STRING,
    role: {
      type: DataTypes.STRING,
      defaultValue: 'user'
    }

  });

  User.associate = (models) => {
    User.hasMany(models.WasteLog, { foreignKey: 'userId' });
    User.hasMany(models.PickupRequest, { foreignKey: 'collectorId' });
  };

  return User;
};