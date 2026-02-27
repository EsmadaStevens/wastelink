'use strict';

module.exports = (sequelize, DataTypes) => {
  const PickupRequest = sequelize.define('PickupRequest', {

    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },

    status: {
      type: DataTypes.STRING,
      defaultValue: 'pending'
    }

  });

  PickupRequest.associate = (models) => {
    PickupRequest.belongsTo(models.WasteLog, {
      foreignKey: 'WasteLogId'
    });

    PickupRequest.belongsTo(models.User, {
      foreignKey: 'collectorId',
      as: 'collector'
    });
  };

  return PickupRequest;
};