import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

export default class extends Controller {
  static targets = ['item', 'input', 'form', 'label']

  showInput(event) {
    if (!this.itemTarget.classList.contains('editing')) {
      this.itemTarget.classList.add('editing')
      this.inputTarget.focus()
      this.inputTarget.setSelectionRange(
        this.inputTarget.value.length,
        this.inputTarget.value.length
      )
    }
  }

  submitForm(event) {
    if (this.inputTarget.value != this.labelTarget.textContent) {
      Rails.fire(this.formTarget, 'submit')
    } else {
      this.itemTarget.classList.remove('editing')
    }
  }

  escapeInput(event) {
    if (event.key === 'Escape') {
      this.inputTarget.value = this.labelTarget.textContent
      this.inputTarget.blur()
    }
  }
}