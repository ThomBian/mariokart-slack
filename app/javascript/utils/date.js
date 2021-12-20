//
// day:
// The representation of the day.
// Possible values are "numeric", "2-digit".

// weekday:
// The representation of the weekday.
// Possible values are "narrow", "short", "long".

// year:
// The representation of the year.
// Possible values are "numeric", "2-digit".

// month:
// The representation of the month.
// Possible values are "numeric", "2-digit", "narrow", "short", "long".

// hour:
// The representation of the hour.
// Possible values are "numeric", "2-digit".

// minute: The representation of the minute.
// Possible values are "numeric", "2-digit".

// second:
// The representation of the second.
// Possible values are "numeric", 2-digit".

// options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };

const formatDateFull = (date) => new Date(date).toLocaleDateString('fr-fr');
const formatDateShort = (date) => new Date(date).toJSON().slice(0,10);

export {
    formatDateFull,
    formatDateShort
}