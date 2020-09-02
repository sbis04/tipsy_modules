package com.souvikbiswas.tipsy

class Result(val calculatedSplitAmount: String, val personCount: Int, val percent: Double) {
    override fun toString(): String {
        return "Result [amount: ${this.calculatedSplitAmount}, count: ${this.personCount}, percent: ${this.percent}]"
    }
}