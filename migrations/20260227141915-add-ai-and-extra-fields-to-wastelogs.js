'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addColumn('WasteLogs', 'quantityRange', {
      type: Sequelize.STRING,
      allowNull: true
    });

    await queryInterface.addColumn('WasteLogs', 'lga', {
      type: Sequelize.STRING,
      allowNull: true
    });

    await queryInterface.addColumn('WasteLogs', 'imageUrl', {
      type: Sequelize.STRING,
      allowNull: true
    });

    await queryInterface.addColumn('WasteLogs', 'aiPrediction', {
      type: Sequelize.STRING,
      allowNull: true
    });

    await queryInterface.addColumn('WasteLogs', 'aiConfidence', {
      type: Sequelize.FLOAT,
      allowNull: true
    });

    await queryInterface.addColumn('WasteLogs', 'estimatedValue', {
      type: Sequelize.FLOAT,
      allowNull: true
    });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeColumn('WasteLogs', 'quantityRange');
    await queryInterface.removeColumn('WasteLogs', 'lga');
    await queryInterface.removeColumn('WasteLogs', 'imageUrl');
    await queryInterface.removeColumn('WasteLogs', 'aiPrediction');
    await queryInterface.removeColumn('WasteLogs', 'aiConfidence');
    await queryInterface.removeColumn('WasteLogs', 'estimatedValue');
  }
};
