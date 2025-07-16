#[derive(Copy, Drop, Introspect, Serde, Debug, PartialEq)]
pub enum QuestionType {
    multichoice,
    TrueFalse,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
#[dojo::model]
pub struct QuestionCounter {
    #[key]
    pub id: felt252,
    pub current_val: u256,
}

#[derive(Clone, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Question {
    #[key]
    pub id: u256,
    pub text: ByteArray,
    pub question_type: QuestionType,
    pub options: Array<ByteArray>,
    pub correct_option: u8,
    pub duration_seconds: u256,
    pub point: u256,
    pub max_points: u256,
}


pub trait QuestionTrait {
    fn new(id: u256, text: ByteArray, question_type: QuestionType, options: Array<ByteArray>, correct_option: u8, duration_seconds: u256, point: u256, max_points: u256) -> Question;
}

pub impl QuestionImpl of QuestionTrait {
    fn new(id: u256, text: ByteArray, question_type: QuestionType, options: Array<ByteArray>, correct_option: u8, duration_seconds: u256, point: u256, max_points: u256) -> Question {
        Question {
            id,
            text,
            question_type,
            options,
            correct_option,
            duration_seconds,
            point,
            max_points,
        }
    }
}

#[cfg(test)] 
    mod tests{
        use super::*;
        #[test]
        fn test_new_question() {
            let mut options:Array<ByteArray> = ArrayTrait::new();
            options.append("Paris");
            options.append("London");
            options.append("Berlin");
            options.append("Madrid");
            
            let question = QuestionTrait::new(
                1,
                "What is the capital of France?",
                QuestionType::multichoice,
                options,
                0,
                100000,
                10,
                10,
            );
            assert_eq!(question.id, 1);
            assert_eq!(question.text, "What is the capital of France?");
            assert_eq!(question.question_type, QuestionType::multichoice);
            assert!(question.options.len() == 4, "Options length should be 4");
            assert_eq!(question.correct_option, 0);
            assert_eq!(question.duration_seconds, 100000);
            assert_eq!(question.point, 10);
            assert_eq!(question.max_points, 10);
        }

 
        #[test]
        fn test_new_question_with_true_false() {
            let mut options:Array<ByteArray> = ArrayTrait::new();
            options.append("True");
            options.append("False");
            
            let question = QuestionTrait::new(
                1,
                "Is the capital of France is Paris ?",
                QuestionType::TrueFalse,
                options,
                0,
                100000,
                10,
                10,
            );
            assert_eq!(question.id, 1);
            assert_eq!(question.text, "Is the capital of France is Paris ?");
            assert_eq!(question.question_type, QuestionType::TrueFalse);
            assert!(question.options.len() == 2, "Options length should be 2");
            assert_eq!(question.correct_option, 0);
            assert_eq!(question.duration_seconds, 100000);
            assert_eq!(question.point, 10);
            assert_eq!(question.max_points, 10);
        }
    }
