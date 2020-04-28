function [line_k,line_b] = k_b_of_line(finesubCand_left, finesubCand_right)
line_k = (finesubCand_right(2) - finesubCand_left(2)) / (finesubCand_right(1) - finesubCand_left(1));
line_b = finesubCand_left(2) - line_k * finesubCand_left(1);
