import moment from 'moment'

const formatDateFull = (date) => new Date(date).toLocaleDateString('fr-fr');

export {
    formatDateFull
}