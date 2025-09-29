### 🙂 Author Profiling for gender, age, industry classification
Currently, I'm experimenting different approaches to get high accuracy in the classification of gender, age and industry.
Here you can see what methods I have been using

MTAP (NLP): BERT + char BiLSTM / word CNN / LDA features on Blog Authorship Corpus (~700k posts) 
→ 69% gender / 65% age / 39% industry val accuracy. (This project is under development)

Naive Bayes:
→ 68% gender / 65% age / 19% industry val accuracy 

Built a multi-task author-profiling model (gender/age/industry) with BERT embeddings + char BiLSTM, word CNN, topic LDA.
Best val accuracy: 69% (gender), 65% (age), 39% (industry); tracked F1 & confusion matrices.
Ablations/tuning: DistilBERT, RoBERTa, adapters, XGBoost, gradient clipping, dynamic loss weighting, dropout, AdamW, layer freezing. Continued MLM pretraining & simple data augmentation & DAPT were unstable / no gain.
Resources: Blog Authorship Corpus (~700k posts); bert-base-uncased; PyTorch, HF Transformers, scikit-learn; Colab GPU (T4/L4, AMP)
