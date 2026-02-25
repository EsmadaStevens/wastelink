"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class WasteLog extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association
      WasteLog.belongsTo(models.User, { foreignKey: "userId" });
      models.User.hasMany(WasteLog, { foreignKey: "userId" });
    }
  }
  WasteLog.init(
    {
      userId: DataTypes.INTEGER,
      category: DataTypes.STRING,
      volume: DataTypes.STRING,
      photoUrl: DataTypes.STRING,
      status: DataTypes.STRING,
      valueEstimate: DataTypes.FLOAT,
      lga: {
        // <-- add this
        type: DataTypes.STRING,
        allowNull: false, // require every waste log to have an LGA
      },
      imageUrl: {
        type: DataTypes.STRING,
      },
      aiPrediction: {
        type: DataTypes.STRING,
      },
      aiConfidence: {
        type: DataTypes.FLOAT,
      },
    },
    {
      sequelize,
      modelName: "WasteLog",
    },
  );
  return WasteLog;
};
