"use strict";

module.exports = (sequelize, DataTypes) => {
  const WasteLog = sequelize.define("WasteLog", {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    wasteType: DataTypes.STRING,
    volume: {
      type: DataTypes.ENUM("low", "medium", "high", "veryhigh"),
      allowNull: false,
    },

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
