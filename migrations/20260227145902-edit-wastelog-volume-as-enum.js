'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.changeColumn('WasteLogs', 'volume', {
      type: Sequelize.ENUM('low', 'medium', 'high', 'veryhigh'),
      allowNull: false,
    });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.changeColumn('WasteLogs', 'volume', {
      type: Sequelize.FLOAT,
      allowNull: true,
    });
  }
};
