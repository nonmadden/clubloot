'use strict'

mongoose = require 'mongoose'
Float = require('mongoose-float').loadType(mongoose)

Schema = mongoose.Schema

ledgerSchema = new Schema
  action: { type: String, enum: ['plus', 'minus'] }
  user: {
    id: String
    name: String
    email: String
  }
  transaction: {
    format: { type: String, enum: ['loot', 'contest', 'won', 'gem', 'prize'] }
    status: String
    ref: [
      {
        format: String
        id: String
      }
    ]
    from: String
    to: String
    amount: Float
    tax: Float
    tracking_number: String
    carrier: String
  }
  balance: {
    diamonds: { type: Number, default: 0 }
    emeralds: { type: Number, default: 0 }
    sapphires: { type: Number, default: 0 }
    rubies: { type: Number, default: 0 }
    coins: { type: Number, default: 0 }
  }
  created_at: Date
  updated_at: Date

ledgerSchema.pre 'save', (next) ->
  now = new Date
  @updated_at = now
  if !@created_at
    @created_at = now
  next()

module.exports = mongoose.model 'ledger', ledgerSchema
