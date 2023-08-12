#ifndef DATASET_H
#define DATASET_H

/**
 * @file dataset
 * @brief Some tricky use cases for MiniOxygen
 * @unknown_keyword with description
 * @unknow_keyword_without_description
 *
 * Here we throw every borderline case we can think of to try to break
 * the minioxygen c parser. And usually we succeed.
 */

/**
 * @enum dataset_enum_t
 * @brief Enum for dataset containing random stressful stuff
 * Not much to say here
 */
typedef enum {
    /* a normal comment not to be interpreted */
    DATASET_ENUM_0 = 0, /**< Enum 0 post-info here */
    /* another comment */
    /** Enum 1 pre-info here */
    DATASET_ENUM_1 = 1,
    DATASET_ENUM_2 = 2, /**< Enum 2 post-info here */ /* another one */
    DATASET_ENUM_3 = 3, /**< Enum 3 post-info here */
    /** Enum 4 pre-info info */
    DATASET_ENUM_4 = 4,
    DATASET_ENUM_COUNT /**< How many entries in this enum */
    /* a normal comment after the last element */
} dataset_enum_t;

/**
 * @function dataset_test_run
 * @brief Short description here
 * @param x random param
 * @return nothing
 */
void dataset_test_run(int x);

/**
 * @struct struct data_struct_example
 * @brief some weird structure just to stress-test the parser
 * Nothing to say
 */
typedef struct dataset_struct_example {
  /* i don't recommend typedefing structs, but a lot of people just don't listen */
  int i; /**< i, post-documentation */
  /* another random comment */
  /**< long_int, pre-documentation */
  unsigned long int long_int; /* random comment */
  volatile unsigned long int volatile_long_int; /**< volatile_long_int, post-documenting */
  /**< sub_struct, pre-documentation */
  volatile const struct dataset_sub_struct sub_struct;
  /* anonymous union */
  union {
    unsigned long ul;
    unsigned short us;
    unsigned char uc;
    long l;
    short s;
    char c;
  } anon_union;
  /* anonymous struct */
  struct {
    unsigned long ul;
    unsigned short us;
    unsigned char uc;
    long l;
    short s;
    char c;
  } anon_struct;
  
} dataset_struct_example_t;

#endif
