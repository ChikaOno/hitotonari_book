class WholeAnswersController < ApplicationController
  
    
  def index
    @whole_answer = WholeAnswer.all
  end

  def show
    @whole_answer = WholeAnswer.find(params[:id])
  end

  def new
    @book = Book.find(params[:book_id])
    @whole_answer = Book.find(params[:book_id]).whole_answers.build
    
    if params[:whole_question_id].blank?
      # whole_questionsを持っておいて、１個ずつ減らしていく
      @whole_question = WholeQuestion.where(required: true).first
      @whole_answer.whole_question = @whole_question
      @detailed_answers = Array.new
      @whole_question.detailed_questions.each do |detailed_question|
        @whole_answer.detailed_answers.build(detailed_question_id: detailed_question.id)
      end

      # base_periodの選択部分
      @base_periods = BasePeriod.where(book_id: @book.id)
      @whole_answer.periods.build
    else
      # whole_questionsを持っておいて、１個ずつ減らしていく
      @whole_question = WholeQuestion.find_by(id: params[:whole_question_id])
      @whole_answer.whole_question = @whole_question
      @detailed_answers = Array.new
      @whole_question.detailed_questions.each do |detailed_question|
        @whole_answer.detailed_answers.build(detailed_question_id: detailed_question.id)
      end

      # base_periodの選択部分
      @base_periods = BasePeriod.where(book_id: @book.id)
      @whole_answer.periods.build
    end
  end

  def create
    @whole_answer = Book.find(params[:book_id]).whole_answers.build(detailed_answer_params)
    if @whole_answer.save
      if params[:whole_answer][:whole_question_id].to_i == WholeQuestion.where(required: true).last.id
        flash[:success] = '回答を保存しました。'
        redirect_to root_url
      else
        whole_questions = WholeQuestion.where(required: true)
        id_of_next_whole_question = whole_questions[whole_questions.index { |k| k.id == params[:whole_answer][:whole_question_id].to_i} + 1].id
        redirect_to new_whole_answer_path(whole_question_id: id_of_next_whole_question, book_id: params[:book_id])
      end
    else
      flash.now[:danger] = '回答保存に失敗しました。'
      render 'toppages/index'
    end
  end

  def edit
    @whole_answer = WholeAnswer.find(params[:id])
  end

  def update
    @whole_answer = WholeAnswer.find(params[:id])

    if @whole_answer.update(detailed_answer_params)
      flash[:success] = '回答 は正常に更新されました'
      redirect_to @whole_answer
    else
      flash.now[:danger] = '回答 は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @whole_answer = WholeAnswer.find(params[:id])
    @@whole_answer.destroy
    flash[:success] = '回答を削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def detailed_answer_params
    params.require(:whole_answer).permit(:whole_question_id, detailed_answers_attributes: [:content, :detailed_question_id], periods_attributes: [:base_period_id])
  end
  
end
    
