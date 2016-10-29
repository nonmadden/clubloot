'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

PrizeSchema = new Schema
  name: String
  price: Number
  active: Boolean

module.exports = mongoose.model 'Prize', PrizeSchema
