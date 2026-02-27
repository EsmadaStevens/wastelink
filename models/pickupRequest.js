'use strict';

module.exports = (sequelize, DataTypes) => {
  const PickupRequest = sequelize.define(
    'PickupRequest',
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
      },
      WasteLogId: {
        type: DataTypes.INTEGER,
        allowNull: false
      },
      collectorId: {
        type: DataTypes.INTEGER,
        allowNull: true
      },
      status: {
        type: DataTypes.ENUM('pending', 'accepted', 'collected', 'cancelled'),
        defaultValue: 'pending'
      },
      scheduledAt: {
        type: DataTypes.DATE,
        allowNull: true
      }
    },
    {
      tableName: 'PickupRequests',
      timestamps: true
    }
  );

  PickupRequest.associate = (models) => {
    PickupRequest.belongsTo(models.WasteLog, {
      foreignKey: 'WasteLogId',
      as: 'wasteLog'
    });

    PickupRequest.belongsTo(models.User, {
      foreignKey: 'collectorId',
      as: 'collector'
    });
  };

  return PickupRequest;
};