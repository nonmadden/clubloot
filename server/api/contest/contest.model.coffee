'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ContestSchema = new Schema
  name: String
  program: String
  owner: String
  participant: []
  prize: Number
  loot: {
    prize: Number
    category: String
  }
  status: String
  challenge: Number
  max_player: Number
  payer: [
    {
      uid: String
      score: Number
    }
  ]


  fee: Number
  public: Boolean

module.exports = mongoose.model 'Contest', ContestSchema
