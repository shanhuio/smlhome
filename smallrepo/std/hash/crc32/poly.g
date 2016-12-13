const (
    // IEEE is by far and away the most common CRC-32 polynomial.
    // Used by ethernet (IEEE 802.3), v.42, fddi, gzip, zip, png, ...
    IEEE = 0xedb88320

    // Castagnoli's polynomial, used in iSCSI.
    // Has better error detection characteristics than IEEE.
    // http://dx.doi.org/10.1109/26.231911
    Castagnoli = 0x82f63b78

    // Koopman's polynomial.
    // Also has better error detection characteristics than IEEE.
    // http://dx.doi.org/10.1109/DSN.2002.1028931
    Koopman = 0xeb31d82e
)
