"use strict";

module.exports = (sequelize, DataTypes) => {
  const WasteLog = sequelize.define("WasteLog", {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    wasteType: DataTypes.STRING,
    volume: DataTypes.FLOAT,

    status: {
      type: DataTypes.STRING,
      defaultValue: "pending",
    },
    quantityRange: DataTypes.STRING,
    lga: DataTypes.STRING,
    imageUrl: DataTypes.STRING,
    aiPrediction: DataTypes.STRING,
    aiConfidence: DataTypes.FLOAT,
    estimatedValue: DataTypes.FLOAT,
  });

  WasteLog.associate = (models) => {
    WasteLog.belongsTo(models.User, {
      foreignKey: "userId",
    });

    WasteLog.hasOne(models.PickupRequest, {
      foreignKey: "WasteLogId",
    });
  };

  return WasteLog;
};
