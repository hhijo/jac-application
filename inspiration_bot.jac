# inspiration_bot.jac

# This program demonstrates Jac's scale-agnostic walkers
# (runnable locally and servable as API endpoints)
# and integration with byLLM for AI-enhanced responses.

# --- Step 5: Scale Agnostic Approach (Local and Serve) ---

# The 'init' node is the entry point for all Jac programs
node init {
    # FIX: Using square brackets [] for the list definition in older Jac versions
    has quotes = [
        "The best way to predict the future is to create it. - Peter Drucker",
        "Believe you can and you're halfway there. - Theodore Roosevelt",
        "The only way to do great work is to love what you do. - Steve Jobs",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. - Winston Churchill",
        "Strive not to be a success, but rather to be of value. - Albert Einstein"
    ];
};

# --- Core Interaction Walker: Random Quote ---
# This walker can be run locally or become an API endpoint: /inspire_me
walker inspire_me {
    has anchor_node;
    
    # The 'here' keyword refers to the current node the walker is on (the 'init' node in this case)
    anchor_node = here;
    
    # Method to pick and return a random quote
    with entry {
        # Python block to handle the random selection
        py {
            import random
            
            # The 'here' variable refers to the Jac object (node) the walker is currently on
            quotes = here.quotes;
            
            # Assign the result back to the walker's context (stored in 'walker')
            walker.result = random.choice(quotes);
        }
    }
    
    # Final step of the walker execution
    with exit {
        # Return the result stored in the walker's context
        return walker.result;
    }
}

# --- Step 6: AI-Enhanced Walker with byLLM ---
# This walker can be run locally or become an API endpoint: /personalized_inspiration
walker personalized_inspiration {
    has mood: str;
    has llm_result: str;
    
    # Method to interact with the LLM
    with entry {
        # Import the byLLM module for AI integration
        import byLLM;
        
        # Python block to interact with the LLM API
        # NOTE: This requires you to have the appropriate API key set as an environment variable (e.g., OPENAI_API_KEY)
        py {
            # Define the prompt using the user's mood input
            prompt = (
                f"You are a compassionate, witty, and deeply inspiring bot. "
                f"The user's current mood is '{walker.mood}'. "
                f"Generate a concise (max 3 sentences), highly personalized, "
                f"and encouraging inspirational message based on this mood. "
                f"Do not use markdown formatting (like **bold** or bullet points)."
            );
            
            # Instantiate the LLM client (assuming GPT-4o-mini is available and set up via byLLM)
            # byLLM automatically picks up API keys from environment variables
            llm = byLLM.LLM();
            
            # Call the LLM to generate the message
            # The result is assigned to the walker's 'llm_result' field
            walker.llm_result = llm.generate(
                model_name="gpt-4o-mini",
                prompt=prompt
            );
        }
    }
    
    # Final step of the walker execution
    with exit {
        return {
            "mood_input": walker.mood,
            "personalized_message": walker.llm_result
        };
    }
}

# The main execution block
can entry {
    # Initialize the graph by creating the 'init' node
    # The 'spawn' keyword creates the node and returns it
    spawn init;
    
    # Move the context to the 'init' node
    here;
}