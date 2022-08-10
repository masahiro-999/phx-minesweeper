
export default {
  mounted() {
    const hook = this;

    const selector = '#' + this.el.id;
    this.el.addEventListener('drop', drop);

    function extract_number(val) {
        // input :"#cell99"
        // output : "99"
        result = val.match(/\d+/g)
        if (result.length >0) {
            return result[0]
        } else {
            return -1
        }
    }
    function drop(e) {
        hook.pushEventTo(selector, 'dropped', {
            pos: extract_number(selector),
          });
    }
  },
}