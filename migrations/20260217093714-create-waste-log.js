"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("WasteLogs", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      userId: {
        type: Sequelize.INTEGER,
      },
      category: {
        type: Sequelize.ENUM("plastic", "organic", "paper", "metal", "general"),
        allowNull: false,
      },
      volume: {
        type: Sequelize.ENUM("small", "medium", "large", "extra_large"),
        allowNull: false,
      },
      photoUrl: {
        type: Sequelize.STRING,
      },
      status: {
        type: Sequelize.ENUM("pending", "validated", "rejected"),
        defaultValue: "pending",
      },
      valueEstimate: {
        type: Sequelize.FLOAT,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      userId: {
        type: Sequelize.INTEGER,
        references: {
          model: "Users",
          key: "id",
        },
        onDelete: "CASCADE",
      },
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable("WasteLogs");
  },
};
