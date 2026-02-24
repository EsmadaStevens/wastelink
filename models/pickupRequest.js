'use strict';

module.exports = (sequelize, DataTypes) => {
  const PickupRequest = sequelize.define(
    'PickupRequest',
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        allowNull: false
      },
      WasteLogId: {
        type: DataTypes.UUID,
        allowNull: false
      },
      collectorId: {
        type: DataTypes.UUID,
        allowNull: false
      },
      status: {
        type: DataTypes.ENUM('pending', 'scheduled', 'collected', 'cancelled'),
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
    // Connect PickupRequest to WasteLog
    PickupRequest.belongsTo(models.WasteLog, {
      foreignKey: 'WasteLogId',
      as: 'wasteLog'
    });

    // Connect PickupRequest to User (collector)
    PickupRequest.belongsTo(models.User, {
      foreignKey: 'collectorId',
      as: 'collector'
    });
  };

  return PickupRequest;
};